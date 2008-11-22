Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYKVA6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYKVA6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 19:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbYKVA6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 19:58:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754664AbYKVA6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 19:58:23 -0500
Date: Fri, 21 Nov 2008 16:58:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, Eric.Piel@tremplin-utc.net, trenn@suse.de,
       rpurdie@rpsys.net, hmh@hmh.eng.br
Subject: Re: HP accelerometer: split chip handling from HP ACPI interface
Message-Id: <20081121165802.a5b8dd67.akpm@linux-foundation.org>
In-Reply-To: <20081121212121.GA7222@elf.ucw.cz>
References: <20081121212121.GA7222@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 22:21:21 +0100
Pavel Machek <pavel@suse.cz> wrote:

> This patch splits handling between chip-specific lis3lv02d and HP/ACPI
> specific hp_accel.c.

i386 allmodconfig:

ERROR: "lis3lv02d_acpi_write" [drivers/hwmon/lis3lv02d.ko] undefined!
ERROR: "lis3lv02d_acpi_init" [drivers/hwmon/lis3lv02d.ko] undefined!
ERROR: "lis3lv02d_acpi_read" [drivers/hwmon/lis3lv02d.ko] undefined!
ERROR: "lis3lv02d_remove_fs" [drivers/hwmon/hp_accel.ko] undefined!
ERROR: "adev" [drivers/hwmon/hp_accel.ko] undefined!
ERROR: "lis3lv02d_joystick_disable" [drivers/hwmon/hp_accel.ko] undefined!
ERROR: "lis3lv02d_init_device" [drivers/hwmon/hp_accel.ko] undefined!
ERROR: "lis3lv02d_poweroff" [drivers/hwmon/hp_accel.ko] undefined!
ERROR: "lis3lv02d_poweron" [drivers/hwmon/hp_accel.ko] undefined!
