Return-Path: <linux-kernel-owner+w=401wt.eu-S1767330AbXDFAem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767330AbXDFAem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767458AbXDFAem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:34:42 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40190 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767330AbXDFAel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:34:41 -0400
Message-Id: <1175819681.20754.1183287946@webmail.messagingengine.com>
X-Sasl-Enc: qhFgk6krI9uniJCcAiZWHIzyWayv6/oAOQrvaHuOxV6o 1175819681
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
Subject: Re: Reiser4. BEST FILESYSTEM EVER? I need help.
In-Reply-To: <461592FB.5060507@zytor.com>
Date: Thu, 05 Apr 2007 17:34:41 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yeap, I guess that will probably work. 

And here I was trying to compile old versions of GRUB from namesys.com.

By the way, do you think the benchmarks from:

http://linuxhelp.150m.com/resources/fs-benchmarks.htm and
http://m.domaindlx.com/LinuxHelp/resources/fs-benchmarks.htm

are accurate?

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

Thanks for that, John.


On Thu, 05 Apr 2007 17:23:23 -0700, "H. Peter Anvin" <hpa@zytor.com>
said:
> johnrobertbanks@fastmail.fm wrote:
> > 
> > Anyway, I have patched the 2.6.20 kernel and have a partition formatted
> > with Reiser4.
> > 
> > However, I am having trouble getting LILO or GRUB working (with
> > Reiser4).
> > 
> > Could you guys who know all about this, help me, or point me to some
> > help.
> > 
> 
> Make your /boot a separate partition and format it as conservatively as 
> possible (e.g. ext3, or even ext2.)
> 
> Problem solved.
> 
> 	-hpa
-- 
  
  johnrobertbanks@fastmail.fm

-- 
http://www.fastmail.fm - Send your email first class

