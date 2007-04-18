Return-Path: <linux-kernel-owner+w=401wt.eu-S2992788AbXDRQNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992788AbXDRQNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 12:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992789AbXDRQNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 12:13:31 -0400
Received: from queue01-pub.suddenlink.net ([208.180.40.86]:37171 "EHLO
	que01.suddenlink.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992788AbXDRQNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 12:13:30 -0400
X-Greylist: delayed 1684 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2007 12:13:30 EDT
Message-ID: <001601c781d0$9c424d40$6207a8c0@rankinp35>
From: "david rankin" <drankinatty@suddenlinkmail.com>
To: "kernel" <linux-kernel@vger.kernel.org>
Subject: built 2.6.20.7 on suse 10.0, boots fine, no mouse, network or keyboard
Date: Wed, 18 Apr 2007 10:45:37 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mates,

    First post and I am having heck building the vanilla 2.6.20.7 kernel on 
Suse 10.0. Basically I put 2.6.20.7 in /usr/src, then I did

cd linux
(read Documentation/Changes "Current Minimal Requirements")
zcat /proc/config.gz > .config
make oldconfig
make
make modules
make modules_install
make install.
edit grub to boot from new and old kernels.

    All current minimal requierments are met *except* udev which is version 
068. Everything compiled and installed properly and initrd did what it was 
supposed to:

providence:/usr/src/linux # ll /boot
total 17184
-rw-------   1 root root     512 2006-08-12 17:09 backup_mbr
lrwxrwxrwx   1 root root       1 2006-08-12 16:56 boot -> .
drwxr-xr-x   2 root root     544 2007-04-17 22:22 grub
lrwxrwxrwx   1 root root      19 2007-04-17 22:21 initrd -> 
initrd-2.6.20.7-smp
-rw-r--r--   1 root root 1800590 2007-04-17 22:21 initrd-2.6.20.7-smp
lrwxrwxrwx   1 root root      23 2007-04-16 19:59 initrdold -> 
initrd-2.6.13-15.15-smp
-rw-r--r--   1 root root   90292 2005-09-09 11:36 memtest.bin
-rw-r--r--   1 root root  128000 2006-08-12 17:09 message
-rw-r--r--   1 root root  779055 2007-03-02 10:33 
System.map-2.6.13-15.15-smp
-rw-r--r--   1 root root  860395 2007-04-17 22:01 System.map-2.6.20.7-smp
-rw-r--r--   1 root root 1991337 2007-03-02 10:42 
vmlinux-2.6.13-15.15-smp.gz
lrwxrwxrwx   1 root root      20 2007-04-17 22:20 vmlinuz -> 
vmlinuz-2.6.20.7-smp
-rw-r--r--   1 root root 1684799 2007-03-02 10:33 vmlinuz-2.6.13-15.15-smp
-rw-r--r--   1 root root 1562784 2007-04-17 22:01 vmlinuz-2.6.20.7-smp
lrwxrwxrwx   1 root root      24 2007-04-16 19:59 vmlinuzold -> 
vmlinuz-2.6.13-15.15-smp

The 2.6.20.7 kernel boots just fine and all services are started *except* 
keyboard, mouse and network. Is this udev??? If so, can I safely update udev 
without destroying my 2.6.13-15.15 setup?? Can it be anything else?? Any 
help would be appreciated.

Thanks!


--
David C. Rankin, J.D., P.E.
510 Ochiltree Street
Nacogdoches, Texas 75961
(936) 715-9333
(936) 715-9339 fax
www.rankinlawfirm.com
-- 

