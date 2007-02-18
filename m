Return-Path: <linux-kernel-owner+w=401wt.eu-S933162AbXBRJj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162AbXBRJj6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 04:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933164AbXBRJj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 04:39:58 -0500
Received: from smtp-out109.alice.it ([85.37.17.109]:4295 "EHLO
	smtp-out109.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933162AbXBRJj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 04:39:57 -0500
X-Greylist: delayed 850 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Feb 2007 04:39:57 EST
Message-ID: <45D81B89.9070302@alice.it>
Date: Sun, 18 Feb 2007 10:25:29 +0100
From: Mario Vanoni <vanonim@alice.it>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061222 SeaMonkey/1.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.18.6 OK,  2.6.19.3 & 2.6.20 NOT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2007 09:25:45.0993 (UTC) FILETIME=[C4E77790:01C7533E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.18.6 vanilla:
/dev/hda CD/DVD
/dev/hda1 / IDE HD 160GB
/dev/hda2 swap
/dev/sda1 /xyz SATA HD 320GB
/dev/sda2 swap
/dev/sdb1 /zzz SATA HD 320GB
/dev/sdb2 swap
/dev/sdc1 /usb USB KEY 512MB
all 100% OK since 12-Dec-2006

2.6.19.3 vanilla & 2.6.20 vanilla, identical behaviour:
/dev/hda, /dev/hdb OK

fsck 1.38 (30-Jun-2005)
/dev/sda1: clean 2960/125696 files, 12379/125692 blocks
but /dev/sda1 is only partially mounted, du -hs says 33M
...
/sbin/e2fsck: No such file or directory while trying to open /dev/sdb1
...
same for /dev/sdc1
...
swapon: cannot stat /dev/sda2: No such file or directory
same for /dev/sdb2,
so only 2GB swap, not 6GB

AUSUS P4R800V, P4HT3400, 2GB mem
Slackware 11.0, udev-105, gcc-3.4.6, lib-2.3.6, all ext2 formated

Rebooting 2.6.18.6:
/dev/sda1: clean 4434650/77004800 files, 76977447/76977447 blocks
(disk is full, I know), all OK, 6GB swap

FEEDBACK ONLY, _not_ in LMKL

Kind regards
Mario Vanoni

