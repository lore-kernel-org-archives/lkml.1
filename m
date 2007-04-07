Return-Path: <linux-kernel-owner+w=401wt.eu-S965180AbXDGCrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965180AbXDGCrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 22:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965145AbXDGCri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 22:47:38 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52993 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965116AbXDGCrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 22:47:37 -0400
Message-Id: <1175914056.9653.1183426876@webmail.messagingengine.com>
X-Sasl-Enc: ZZA1u7jzcXToFWxBPwcOFHN1qgM4ihCmX4qnFEvYS6QQ 1175914056
From: johnrobertbanks@fastmail.fm
To: "Jan Harkes" <jaharkes@cs.cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <46157B5B.5000602@gmail.com>
   <1175817921.18400.1183285196@webmail.messagingengine.com>
   <461592FB.5060507@zytor.com>
   <1175819681.20754.1183287946@webmail.messagingengine.com>
   <461596DE.2020802@zytor.com>
   <1175823288.25662.1183293506@webmail.messagingengine.com>
   <4615C780.5040407@zytor.com>
   <1175833931.8916.1183307802@webmail.messagingengine.com>
   <20070406152119.GC4228@delft.aura.cs.cmu.edu>
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
In-Reply-To: <20070406152119.GC4228@delft.aura.cs.cmu.edu>
Date: Fri, 06 Apr 2007 19:47:36 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007 11:21:19 -0400, "Jan Harkes" <jaharkes@cs.cmu.edu>
said:
> Do you really have to repeat the results in every email you sent?

The following benchmarks are from

http://linuxhelp.150m.com/resources/fs-benchmarks.htm or,
http://m.domaindlx.com/LinuxHelp/resources/fs-benchmarks.htm

.-------------------------.
| FILESYSTEM | TIME |DISK |
| TYPE       |(secs)|USAGE|
.-------------------------.
|REISER4 lzo | 1938 | 278 |
|REISER4 gzip| 2295 | 213 |
|REISER4     | 3462 | 692 |
|EXT2        | 4092 | 816 |
|JFS         | 4225 | 806 |
|EXT4        | 4408 | 816 |
|EXT3        | 4421 | 816 |
|XFS         | 4625 | 779 |
|REISER3     | 6178 | 793 |
|FAT32       |12342 | 988 |
|NTFS-3g     |10414 | 772 |
.-------------------------.


Column one measures the time taken to complete the bonnie++ benchmarking
test (run with the parameters bonnie++ -n128:128k:0)

Column two, Disk Usage: measures the amount of disk used to store 655MB
of raw data (which was 3 different copies of the Linux kernel sources).

> Do you really have to repeat the results in every email you sent?

Damn, I did it again. WHY DO YOU CARE?

Look, its simple, I am (among other things) discussing these results, so
people need to see them.

> > Don't you agree, that "If they are accurate,.... THEN they are obviously
> > very relevant."
> 
> Not everyone does. I care mostly about reliability and availability
> neither of which are shown by your results.

Actually, to some extent, bonnie++ tests the reliability of the
filesystem, eg, NTFS-3g usually fails.

By the way, I have pulled the plug on my REISER4 system, a number of
times now, and it recovers without problem.

> With compression there is a pretty high probability that one corrupted
> byte or disk block will result in loss of a considerably larger amount
> of data. 

Bad blocks are NOT dealt with by the filesystem,... so your comment is
irrelevant, or just plain wrong.

If your filesystem is writing to bad blocks, then throw away your
operating system.

> > I have set up a Reiser4 partition with gzip compression, here is the
> > difference in disk usage of a typical Debian installation on two 10GB
> > partitions, one with Reiser3 and the other with Reiser4.
> > 
> > debian:/# df
> > Filesystem           1K-blocks      Used Available Use% Mounted on
> > /dev/sda3             10490104   6379164   4110940  61% /3
> > /dev/sda7              9967960   2632488   7335472  27% /7
> ...
> > Partition 3 is Reiser3 -- uses 6.4 GB.
> > Partition 7 is Reiser4 -- uses 2.6 GB.
> > 
> > So Reiser4 uses 2.6 GB to store the (typical) data that it takes Reiser3
> > 6.4 GB to store (note it would take ext2/3/4 some 7 GB to store the same
> > info).
> 
> Wow, consider me totally and completely, unimpressed.
> 

Wow, consider me totally impressed by your AMAZING BIAS.

Would you like to tell me why you are SO BIASED against REISER4.

John.
-- 
  
  johnrobertbanks@fastmail.fm

-- 
http://www.fastmail.fm - A fast, anti-spam email service.

