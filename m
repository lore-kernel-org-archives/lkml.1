Return-Path: <linux-kernel-owner+w=401wt.eu-S1751059AbXDHMya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059AbXDHMya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 08:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXDHMy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 08:54:29 -0400
Received: from relay3.ptmail.sapo.pt ([212.55.154.23]:38239 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751059AbXDHMy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 08:54:28 -0400
X-AntiVirus: PTMail-AV 0.3-0.90.1
Date: Sun, 8 Apr 2007 13:48:11 +0100
From: Jose Celestino <japc@co.sapo.pt>
To: johnrobertbanks@fastmail.fm
Cc: reiserfs-list@namesys.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
Message-ID: <20070408124645.GA8363@co.sapo.pt>
Mail-Followup-To: johnrobertbanks@fastmail.fm, reiserfs-list@namesys.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <461592FB.5060507@zytor.com> <1175819681.20754.1183287946@webmail.messagingengine.com> <461596DE.2020802@zytor.com> <1175823288.25662.1183293506@webmail.messagingengine.com> <4615C780.5040407@zytor.com> <1175833931.8916.1183307802@webmail.messagingengine.com> <20070407191715.GG3510@csclub.uwaterloo.ca> <1175993097.32498.1183512070@webmail.messagingengine.com> <20070408025632.GA17646@thunk.org> <1176005612.15484.1183524228@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176005612.15484.1183524228@webmail.messagingengine.com>
X-URL: http://xpto.org/~japc
X-System: Linux morgoth.sl.pt 2.6.20-1.2943.fc6
X-UP: 16:41:33 up 15:40,  1 user,  load average: 0.31, 0.30, 0.55
X-By: japc@morgoth.sl.pt
X-GPG-key-ID: 0x07B1363B
X-GPG-key-Fingerprint: D3F3 B47B F20C 3B1E 488C B949 1B8B 8141 07B1 363B
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Words by johnrobertbanks@fastmail.fm [Sat, Apr 07, 2007 at 09:13:32PM -0700]:
> Teddy,
> 
> It is a pity you don't address the full set of results, when you make
> your snide comments.
> 
> Now since you have them,... why don't you make reasoned comment about
> them.
> 
> You can read more here:
> 

John,

it is not because you keep posting the same numbers over and over again
(or is this your new signature?) that they will be more substantiated
(hint: cpu usage).
Just more annoying each time.

I'll remember to use reiser4 for my
90-percent-zero-files-no-need-for-proven-robustness-and-plenty-of-cpu-to-spare
boxes. Thank you.

> http://m.domaindlx.com/LinuxHelp/resources/fs-benchmarks.htm
> 
> .-------------------------.
> | FILESYSTEM | TIME |DISK |
> | TYPE       |(secs)|USAGE|
> .-------------------------.
> |REISER4 lzo | 1938 | 278 |
> |REISER4 gzip| 2295 | 213 |
> |REISER4     | 3462 | 692 |
> |EXT2        | 4092 | 816 |
> |JFS         | 4225 | 806 |
> |EXT4        | 4408 | 816 |
> |EXT3        | 4421 | 816 |
> |XFS         | 4625 | 779 |
> |REISER3     | 6178 | 793 |
> |FAT32       |12342 | 988 |
> |NTFS-3g     |10414 | 772 |
> .-------------------------.
> 
> 
> Column one measures the time taken to complete the bonnie++ benchmarking
> test (run with the parameters bonnie++ -n128:128k:0)
> 
> Column two, Disk Usage: measures the amount of disk used to store 655MB
> of raw data (which was 3 different copies of the Linux kernel sources).
> 
> OR LOOK AT THE FULL RESULTS:
> 
> .-------------------------------------------------.
> |File         |Disk |Copy |Copy |Tar  |Unzip| Del |
> |System       |Usage|655MB|655MB|Gzip |UnTar| 2.5 |
> |Type         | (MB)| (1) | (2) |655MB|655MB| Gig |
> .-------------------------------------------------.
> |REISER4 gzip | 213 | 148 |  68 |  83 |  48 |  70 |
> |REISER4 lzo  | 278 | 138 |  56 |  80 |  34 |  84 |
> |REISER4 tails| 673 | 148 |  63 |  78 |  33 |  65 |
> |REISER4      | 692 | 148 |  55 |  67 |  25 |  56 |
> |NTFS3g       | 772 |1333 |1426 | 585 | 767 | 194 |
> |NTFS         | 779 | 781 | 173 |   X |   X |   X |
> |REISER3      | 793 | 184 |  98 |  85 |  63 |  22 |
> |XFS          | 799 | 220 | 173 | 119 |  90 | 106 |
> |JFS          | 806 | 228 | 202 |  95 |  97 | 127 |
> |EXT4 extents | 806 | 162 |  55 |  69 |  36 |  32 |
> |EXT4 default | 816 | 174 |  70 |  74 |  42 |  50 |
> |EXT3         | 816 | 182 |  74 |  73 |  43 |  51 |
> |EXT2         | 816 | 201 |  82 |  73 |  39 |  67 |
> |FAT32        | 988 | 253 | 158 | 118 |  81 |  95 |
> .-------------------------------------------------.
> 
> 
> Each test was preformed 5 times and the average value recorded.
> Disk Usage: The amount of disk used to store the data (which was 3
> different copies of the Linux kernel sources).
> The raw data (without filesystem meta-data, block alignment wastage,
> etc) was 655MB.
> Copy 655MB (1): Copy the data over a partition boundary.
> Copy 655MB (2): Copy the data within a partition.
> Tar Gzip 655MB: Tar and Gzip the data.
> Unzip UnTar 655MB: UnGzip and UnTar the data.
> Del 2.5 Gig: Delete everything just written (about 2.5 Gig).
> 
> 
> To get a feel for the performance increases that can be achieved by
> using compression, we look at the total time (in seconds) to run the
> test:
> 
> bonnie++ -n128:128k:0 (bonnie++ is Version 1.93c)
> 
> .-------------------.
> | FILESYSTEM | TIME |
> .-------------------.
> |REISER4 lzo |  1938|
> |REISER4 gzip|  2295|
> |REISER4     |  3462|
> |EXT4        |  4408|
> |EXT2        |  4092|
> |JFS         |  4225|
> |EXT3        |  4421|
> |XFS         |  4625|
> |REISER3     |  6178|
> |FAT32       | 12342|
> |NTFS-3g     |>10414|
> .-------------------.
> 
> 
> 
> On Sat, 7 Apr 2007 22:56:32 -0400, "Theodore Tso" <tytso@mit.edu> said:
> > On Sat, Apr 07, 2007 at 05:44:57PM -0700, johnrobertbanks@fastmail.fm
> > wrote:
> > > To get a feel for the performance increases that can be achieved by
> > > using compression, we look at the total time (in seconds) to run the
> > > test:
> > 
> > You mean the performance increases of writing a file which is mostly
> > all zero's?  Yawn.....
> > 
> > 					- Ted
> -- 
>   
>   johnrobertbanks@fastmail.fm
> 
> -- 
> http://www.fastmail.fm - IMAP accessible web-mail
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jose Celestino
----------------------------------------------------------------
http://www.msversus.org/     ; http://techp.org/petition/show/1
http://www.vinc17.org/noswpat.en.html
----------------------------------------------------------------
"And on the trillionth day, Man created Gods." -- Thomas D. Pate
