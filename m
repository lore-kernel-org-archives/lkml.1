Return-Path: <linux-kernel-owner+w=401wt.eu-S1767423AbXDFAFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767423AbXDFAFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767449AbXDFAFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:05:24 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54483 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767423AbXDFAFW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:05:22 -0400
Message-Id: <1175817921.18400.1183285196@webmail.messagingengine.com>
X-Sasl-Enc: 70iH39woqlf7p9cEedXu4KbwhwP1cQrRSEPKpUdrFw4r 1175817921
From: johnrobertbanks@fastmail.fm
To: "Ignatich" <ignatich@gmail.com>, reiserfs-list@namesys.com,
       linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <46157B5B.5000602@gmail.com>
Subject: Re: Reiser4. BEST FILESYSTEM EVER? I need help.
In-Reply-To: <46157B5B.5000602@gmail.com>
Date: Thu, 05 Apr 2007 17:05:21 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ignatich,

After seeing the following benchmarks at 

http://linuxhelp.150m.com/resources/fs-benchmarks.htm and
http://m.domaindlx.com/LinuxHelp/resources/fs-benchmarks.htm

The Reiser4 benchmarks are so good, I have decided to try the Reiser4
filesystem.

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

Anyway, I have patched the 2.6.20 kernel and have a partition formatted
with Reiser4.

However, I am having trouble getting LILO or GRUB working (with
Reiser4).

Could you guys who know all about this, help me, or point me to some
help.

Thanks a lot, John.


On Fri, 06 Apr 2007 02:42:35 +0400, "Ignatich" <ignatich@gmail.com>
said:
> While trying to find the cause of problems with reiser4 in recent 
> kernels I came across this.
> 
> Incomplete write handling seem to be missing from reiser4_write_extent() 
> thanks to reiser4-temp-fix.patch. Strangely, there is a patch by Edward 
> Shishkin that should address that issue, but it is missing from -mm 
> tree. Please check.
> 
>     Max
> 
-- 
  
  johnrobertbanks@fastmail.fm

-- 
http://www.fastmail.fm - And now for something completely different…

