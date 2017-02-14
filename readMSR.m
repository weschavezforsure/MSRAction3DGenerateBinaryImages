binPath = '/Users/wchavez/Downloads/MSR/MSR/bins/';
% For every action
for ai = 1:20
    % For every actor
    for si = 1:10
	% For every episode
        for ei = 1:3
            binfile = [binPath,'a' sprintf('%.02d',ai) '_s' sprintf('%.02d',si) '_e' sprintf('%.02d',ei) '_sdepth.bin'];        
            %if ~exist(binfile,'file');
            %    continue;
            %end;
            disp(binfile);

            fileread = fopen(binfile);      
            if fileread<0
               disp('no such file.');
               continue;
            end

            header = fread(fileread,3,'uint=>uint');
            nnof = header(1); ncols = header(2); nrows = header(3);
            depths = zeros(nrows, ncols, nnof);
	    % For every frame
            for f = 1:nnof
                frame = zeros(nrows, ncols);
                for row = 1:nrows
                    tempRow = fread(fileread, ncols, 'uint32');
                    frame(row,:) = tempRow;
                end
                frame = frame - min(frame(:));
                frame = uint8(frame);
                %frame = imresize(frame, .25);
                frame(frame>0) = 255;
                imwrite(frame,['MSR-Action3D_Binary_' sprintf('%.02d',ai) '_s' sprintf('%.02d',si) '_e' sprintf('%.02d',ei) '_' sprintf('%.03d',f) '.png']);
                clear tempRow;
            end
            fclose(fileread);
        end
    end
end
