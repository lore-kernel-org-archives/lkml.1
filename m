Return-Path: <linux-kernel-owner+w=401wt.eu-S964862AbXBTNVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862AbXBTNVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 08:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964856AbXBTNVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 08:21:30 -0500
Received: from smtp-out109.alice.it ([85.37.17.109]:1504 "EHLO
	smtp-out109.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964862AbXBTNV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 08:21:29 -0500
Message-ID: <45DAF5D2.1020401@alice.it>
Date: Tue, 20 Feb 2007 14:21:22 +0100
From: Mario Vanoni <vanonim@alice.it>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061222 SeaMonkey/1.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.18.7 OK,  2.6.19.4 & 2.6.20  & 2.6.20.1 NOT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Feb 2007 13:21:25.0966 (UTC) FILETIME=[05CF9EE0:01C754F2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.18.7 vanilla:
/dev/hda CD/DVD
/dev/hda1 / IDE HD 160GB
/dev/hda2 swap
/dev/sda1 /xyz SATA HD 320GB
/dev/sda2 swap
/dev/sdb1 /zzz SATA HD 320GB
/dev/sdb2 swap
/dev/sdc1 /usb USB KEY 512MB
all 100% OK since 12-Dec-2006

2.6.19.4 vanilla & 2.6.20 vanilla & 2.6.20.1 vanilla,
identical behaviour:
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

/dev/sda1: this time >5% free

all 4 kernels same .config from 2.6.18.6,
make oldconfig, Enter on all new questions

AUSUS P4R800V, P4HT3400, 2GB mem
Slackware 11.0, udev-105, gcc-3.4.6, glibc-2.3.6,
all ext2 4096 formated

Rebooting 2.6.18.7:
all devices OK, 6GB swap

FEEDBACK ONLY, _not_ in LMKL

Kind regards
Mario Vanoni

