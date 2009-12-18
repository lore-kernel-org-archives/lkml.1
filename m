Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbZLRCfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbZLRCfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 21:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbZLRCfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 21:35:30 -0500
Received: from senator.holtmann.net ([87.106.208.187]:56386 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZLRCf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 21:35:29 -0500
Subject: Linking issue with THINKPAD_ACPI=y and ALSA subsystem
From: Marcel Holtmann <marcel@holtmann.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 18:35:06 -0800
Message-Id: <1261103706.4041.83.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrique,

so I am seeing the current issue when building 2.6.33-rc1 for a X200
machine:

drivers/built-in.o: In function `volume_alsa_notify_change':
thinkpad_acpi.c:(.text+0x16c135): undefined reference to `snd_ctl_notify'
thinkpad_acpi.c:(.text+0x16c14f): undefined reference to `snd_ctl_notify'
drivers/built-in.o: In function `volume_exit':
thinkpad_acpi.c:(.text+0x17000a): undefined reference to `snd_card_free'
drivers/built-in.o: In function `volume_init':
thinkpad_acpi.c:(.init.text+0xa05c): undefined reference to `snd_card_create'
thinkpad_acpi.c:(.init.text+0xa170): undefined reference to `snd_ctl_new1'
thinkpad_acpi.c:(.init.text+0xa17f): undefined reference to `snd_ctl_add'
thinkpad_acpi.c:(.init.text+0xa1a3): undefined reference to `snd_ctl_new1'
thinkpad_acpi.c:(.init.text+0xa1b2): undefined reference to `snd_ctl_add'
thinkpad_acpi.c:(.init.text+0xa1f0): undefined reference to `snd_card_register'
thinkpad_acpi.c:(.init.text+0xa200): undefined reference to `snd_card_free'
drivers/built-in.o:(.devinit.data+0xfb8): undefined reference to `snd_ctl_boolean_mono_info'

I do have THINKPAD_ACPI=y in my configuration and CONFIG_SND=m.

Regards

Marcel


