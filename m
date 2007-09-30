Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbXI3PwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbXI3PwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbXI3Pvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:51:53 -0400
Received: from anchor-post-33.mail.demon.net ([194.217.242.91]:2881 "EHLO
	anchor-post-33.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756588AbXI3Pvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:51:52 -0400
X-Greylist: delayed 754 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Sep 2007 11:51:52 EDT
Message-ID: <46FFC371.9040805@romig.demon.co.uk>
Date: Sun, 30 Sep 2007 16:40:33 +0100
From: Neil Romig <neil@romig.demon.co.uk>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: File corruption when using kernels 2.6.18+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am using kernel 2.6.17.14, and would like to use newer versions for the wireless code but I get file corruption with any kernel 
more recent than this. My system uses a SiS645DX chipset (it is a rebadged CLEVO D400E) with 5513 IDE.

I get this corruption with read/writes, i.e using "cp", "dd", when compiling software, writing to CD, etc etc. An example:

cp ../Changelog-2.6.18 .
diff Changelog-2.6.18 ../Changelog-2.6.18

16377c16377
<       LD      .top_vmlinux1
---
 >       LD      .tmp_vmlinux1
23954c23954
< Date:   Mon Jul 1% 04:45:11 2006 -0700
---
 > Date:   Mon Jul 10 04:45:11 2006 -0700
24955c24955
<     This is generally useful, but partacularly helps see if it is the same sector
---
 >     This is generally useful, but particularly helps see if it is the same sector
31879c31879
<     [MMC] sdhci: version bump cdhci
---
 >     [MMC] sdhci: version bump sdhci
42955c42955
<     Replace `he temp makefile hacks with proper CONFIG entries, which are also
---
 >     Replace the temp makefile hacks with proper CONFIG entries, which are also
49050c49050
<       and this task is(already holding:
---
 >       and this task is already holding:
[output clipped]

I would suspect a memory problem but memtest86+ gives no errors despite numerous passes, and I get no errors in older kernels. Does 
anyone have any idea what changed in 2.6.18 to cause such an error?

I have tried some obvious things (see thread on linuxquestions.org: 
http://www.linuxquestions.org/questions/showthread.php?t=578200), but I don't understand enough about the kernel to get any further.

Neil.
