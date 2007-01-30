Return-Path: <linux-kernel-owner+w=401wt.eu-S1751363AbXA3KwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbXA3KwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbXA3KwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:52:22 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:33964 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbXA3KwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:52:21 -0500
Subject: Re: [Bluez-devel] trouble with sysfs and bluetooth
From: Marcel Holtmann <marcel@holtmann.org>
To: BlueZ development <bluez-devel@lists.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, maxk@qualcomm.com,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <200701301135.53178.oliver@neukum.name>
References: <200701301135.53178.oliver@neukum.name>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 11:52:08 +0100
Message-Id: <1170154328.27519.27.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.6 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

> I am constantly getting these messages in 2.6.20-rc6 Greg's tree:
> 
> Jan 30 11:26:42 valisk kernel: Bluetooth: Core ver 2.11
> Jan 30 11:26:42 valisk kernel: PM: Adding info for platform:bluetooth
> Jan 30 11:26:42 valisk kernel: kobject_add failed for bluetooth with -EEXIST, don't try to register things with the same name in the same directory.
> Jan 30 11:26:42 valisk kernel:
> Jan 30 11:26:42 valisk kernel: Call Trace:
> Jan 30 11:26:42 valisk kernel:  [<ffffffff802f4e3b>] kobject_shadow_add+0x147/0x17b
> Jan 30 11:26:42 valisk kernel:  [<ffffffff802f5162>] subsystem_register+0x1b/0x2a
> Jan 30 11:26:42 valisk kernel:  [<ffffffff803773db>] class_register+0xbf/0x1bd
> Jan 30 11:26:42 valisk kernel:  [<ffffffff80377a7e>] class_create+0x53/0x71
> Jan 30 11:26:42 valisk kernel:  [<ffffffff881c711c>] :bluetooth:bt_sysfs_init+0x5a/0x8b
> Jan 30 11:26:42 valisk kernel:  [<ffffffff881c701b>] :bluetooth:bt_init+0x1b/0x53
> Jan 30 11:26:42 valisk kernel:  [<ffffffff8023bf0a>] sys_init_module+0x1467/0x15c3
> Jan 30 11:26:42 valisk kernel:  [<ffffffff80208fee>] system_call+0x7e/0x83
> Jan 30 11:26:42 valisk kernel:
> Jan 30 11:26:42 valisk kernel: PM: Removing info for platform:bluetooth
> Jan 30 11:26:43 valisk kernel: Bluetooth: Core ver 2.11
> Jan 30 11:26:44 valisk kernel: PM: Adding info for platform:bluetooth
> Jan 30 11:26:44 valisk kernel: kobject_add failed for bluetooth with -EEXIST, don't try to register things with the same name in the same directory.
> Jan 30 11:26:44 valisk kernel:
> Jan 30 11:26:44 valisk kernel: Call Trace:
> Jan 30 11:26:45 valisk kernel:  [<ffffffff802f4e3b>] kobject_shadow_add+0x147/0x17b
> Jan 30 11:26:45 valisk kernel:  [<ffffffff802f5162>] subsystem_register+0x1b/0x2a
> Jan 30 11:26:45 valisk kernel:  [<ffffffff803773db>] class_register+0xbf/0x1bd
> Jan 30 11:26:45 valisk kernel:  [<ffffffff80377a7e>] class_create+0x53/0x71
> Jan 30 11:26:46 valisk kernel:  [<ffffffff881c711c>] :bluetooth:bt_sysfs_init+0x5a/0x8b
> Jan 30 11:26:46 valisk kernel:  [<ffffffff881c701b>] :bluetooth:bt_init+0x1b/0x53
> Jan 30 11:26:46 valisk kernel:  [<ffffffff8023bf0a>] sys_init_module+0x1467/0x15c3
> Jan 30 11:26:46 valisk kernel:  [<ffffffff80208fee>] system_call+0x7e/0x83
> Jan 30 11:26:46 valisk kernel:

do you see them also with the plain vanilla 2.6.20-rc6 kernel or are
these only coming up in Greg's tree?

Regards

Marcel


