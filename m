Return-Path: <linux-kernel-owner+w=401wt.eu-S1767490AbXDFBeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767490AbXDFBeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 21:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767487AbXDFBeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 21:34:50 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60917 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767486AbXDFBet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 21:34:49 -0400
Message-Id: <1175823288.25662.1183293506@webmail.messagingengine.com>
X-Sasl-Enc: F4xEVW5PUhSxjFecK6uvQP6jD9YOcbx8kaGyIa0TmJT1 1175823288
From: johnrobertbanks@fastmail.fm
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ignatich" <ignatich@gmail.com>, reiserfs-list@namesys.com,
       linux-kernel@vger.kernel.org
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
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
In-Reply-To: <461596DE.2020802@zytor.com>
Date: Thu, 05 Apr 2007 18:34:48 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

You say that the results may be accurate, but not relevant.

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

If they are accurate,.... THEN they are obviously very relevant.

Trying to follow http://linuxhelp.150m.com/resources/fs-benchmarks.htm 

I have set up a Reiser4 partition with gzip compression, here is the
difference in disk usage of a typical Debian installation on two 10GB
partitions, one with Reiser3 and the other with Reiser4.

debian:/# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda3             10490104   6379164   4110940  61% /3
/dev/sda7              9967960   2632488   7335472  27% /7

Partitions 3 and 7 have exactly the same data on them (the typical
Debian install).

The partitions are exactly the same size (although df records different
sizes).

Partition 3 is Reiser3 -- uses 6.4 GB.
Partition 7 is Reiser4 -- uses 2.6 GB.

So Reiser4 uses 2.6 GB to store the (typical) data that it takes Reiser3
6.4 GB to store (note it would take ext2/3/4 some 7 GB to store the same
info).

This seems very relevant to me.

John.



On Thu, 05 Apr 2007 17:39:58 -0700, "H. Peter Anvin" <hpa@zytor.com>
said:
> johnrobertbanks@fastmail.fm wrote:
> > Yeap, I guess that will probably work. 
> > 
> > And here I was trying to compile old versions of GRUB from namesys.com.
> > 
> > By the way, do you think the benchmarks from:
> > 
> > http://linuxhelp.150m.com/resources/fs-benchmarks.htm and
> > http://m.domaindlx.com/LinuxHelp/resources/fs-benchmarks.htm
> > 
> > are accurate?
> > 
> 
> Accurate, probably.  Whether or not they're *relevant* is a totally 
> different ball of wax.
> 
> 	-hpa
-- 
  
  johnrobertbanks@fastmail.fm

-- 
http://www.fastmail.fm - mmm... Fastmail...

