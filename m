Return-Path: <linux-kernel-owner+w=401wt.eu-S932370AbXBXPoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbXBXPoZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 10:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932714AbXBXPoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 10:44:24 -0500
Received: from smtp-out109.alice.it ([85.37.17.109]:1342 "EHLO
	smtp-out109.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370AbXBXPoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 10:44:24 -0500
Message-ID: <45E05D54.10508@alice.it>
Date: Sat, 24 Feb 2007 16:44:20 +0100
From: Mario Vanoni <vanonim@alice.it>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061222 SeaMonkey/1.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.16.41 & 2.6.18.7 OK,   2.6.19.5 NOT,   2.6.18.8 KERNEL PANIC
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Feb 2007 15:44:22.0048 (UTC) FILETIME=[A734E200:01C7582A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.18.7 vanilla & 2.6.16.41 vanilla:
/dev/hda CD/DVD
/dev/hda1 / IDE HD 160GB
/dev/hda2 swap
/dev/sda1 /xyz SATA HD 320GB
/dev/sda2 swap
/dev/sdb1 /zzz SATA HD 320GB
/dev/sdb2 swap
/dev/sdc1 /usb USB KEY 512MB
all 100% OK since 12-Dec-2006

2.6.19.5 vanilla:
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

---
2.6.18.8 vanilla: !!!
screen eating leftmost characters, then
kernel panic - not syncing: VFS: Unable to mount root fs on
unknown-block(3,65)
POWER SWITCH ultima ratio
---

all 4 kernels same .config from 2.6.18.6,
make oldconfig, Enter on all new questions

AUSUS P4R800V, P4HT3400, 2GB mem
Slackware 11.0, udev-105, gcc-3.4.6, glibc-2.3.6,
all ext2 4096 formated

Rebooting 2.6.18.7 vanilla:
all devices OK, 6GB swap

FEEDBACK ONLY, _not_ in LMKL

Kind regards
Mario Vanoni


