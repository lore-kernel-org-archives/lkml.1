Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972Ab0CMKvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 05:51:21 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45581 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758961Ab0CMKvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 05:51:17 -0500
Date: Sat, 13 Mar 2010 11:51:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, ACPI mailing list <linux-acpi@vger.kernel.org>
Subject: 2.6.34-rc1: lockdep warning on geode subnotebook
Message-ID: <20100313105109.GA9966@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs related? ACPI?

Switching to clocksource acpi_pm
Switched to NOHz mode on CPU #0
BUG: key df3f6edc not in .data!
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x448/0x500()
Hardware name: SA Series
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.34-rc1-00005-g522dba7 #18
Call Trace:
 [<c07ce4fa>] ? printk+0x18/0x1a
 [<c025b278>] ? lockdep_init_map+0x448/0x500
 [<c02354ec>] warn_slowpath_common+0x6c/0xc0
 [<c025b278>] ? lockdep_init_map+0x448/0x500
 [<c0235555>] warn_slowpath_null+0x15/0x20
 [<c025b278>] lockdep_init_map+0x448/0x500
 [<c02f05f8>] sysfs_add_file_mode+0x58/0xb0
 [<c02f0663>] sysfs_add_file+0x13/0x20
 [<c02f071c>] sysfs_create_file+0x1c/0x30
 [<c0461193>] device_create_file+0x13/0x20
 [<c05a71ff>] thermal_zone_device_register+0x48f/0x650
 [<c03e65f2>] acpi_thermal_add+0x1b9/0x3f0
 [<c03bb30c>] acpi_device_probe+0x44/0x145
 [<c0463eb7>] driver_probe_device+0x97/0x2a0
 [<c0464141>] __driver_attach+0x81/0x90
 [<c046360b>] bus_for_each_dev+0x5b/0x80
 [<c03bb238>] ? acpi_device_remove+0x0/0x90
 [<c0463c99>] driver_attach+0x19/0x20
 [<c04640c0>] ? __driver_attach+0x0/0x90
 [<c0462ec7>] bus_add_driver+0x197/0x290
 [<c03bb238>] ? acpi_device_remove+0x0/0x90
 [<c04643e5>] driver_register+0x75/0x160
 [<c02e9573>] ? proc_mkdir_mode+0x33/0x50
 [<c0ae69ac>] ? acpi_thermal_init+0x0/0x6f
 [<c03bc6e8>] acpi_bus_register_driver+0x3a/0x3e
 [<c0ae69fc>] acpi_thermal_init+0x50/0x6f
 [<c0201123>] do_one_initcall+0x23/0x170
 [<c02711c7>] ? init_irq_proc+0x67/0x80
 [<c0ac936d>] kernel_init+0x13c/0x1db
 [<c0ac9231>] ? kernel_init+0x0/0x1db
 [<c0203136>] kernel_thread_helper+0x6/0x10
---[ end trace a7919e7f17c0a725 ]---
BUG: key df3f6f0c not in .data!
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (62 C)
ACPI: Battery Slot [BAT0] (battery present)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
