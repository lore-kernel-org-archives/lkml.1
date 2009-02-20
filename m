Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZBTNaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZBTNaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 08:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbZBTNaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 08:30:06 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:64393 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbZBTNaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 08:30:04 -0500
To: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org
Subject: linux-next-20090220: insmod: -1 Invalid module format
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200902202229.BDD18292.SFOLMOVFOtFJQH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 20 Feb 2009 22:29:59 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't load kernel module for linux-next-200902{18,19,20} .
linux-next-20090217 was OK.

-----
Linux version 2.6.29-rc5-next-20090220 (root@tomoyo) (gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)) #2 SMP PREEMPT Fri Feb 20 21:20:01 JST 2009
(...snipped...)
Red Hat nash version 5.1.19.6 starting
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Setting up hotplug.
Creating block device nodes.
Loading usbcore.ko module
insmod: error inserting '/lib/usbcore.ko': -1 Invalid module format
Loading ehci-hcd.ko module
(...snipped...)
insmod: error inserting '/lib/ide-gd_mod.ko': -1 Invalid module format
Waiting for driver initialization.
stabilized: open /proc/scsi/scsi: No such file or directory
Scanning and configuring dmraid supported devices
Creating root device.
Mounting root filesystem.
mount: could not find filesystem '/dev/root'
Setting up other filesystems.
Setting up new root fs
setuproot: moving /dev failed: No such file or directory
no fstab.sys, mounting internal defaults
setuproot: error mounting /proc: No such file or directory
setuproot: error mounting /sys: No such file or directory
Switching to new root and running init.
unmounting old /dev
unmounting old /proc
unmounting old /sys
switchroot: mount failed: No such file or directory
init used greatest stack depth: 1344 bytes left
Kernel panic - not syncing: Attempted to kill init!
-----

Config is at http://I-love.SAKURA.ne.jp/tmp/config-next-20090220

Regards.
