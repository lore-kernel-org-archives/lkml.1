Return-Path: <linux-kernel-owner+w=401wt.eu-S1751796AbXBVTlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbXBVTlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 14:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbXBVTlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 14:41:21 -0500
Received: from rtr.ca ([64.26.128.89]:1577 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbXBVTlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 14:41:21 -0500
Message-ID: <45DDF1DF.4020408@rtr.ca>
Date: Thu, 22 Feb 2007 14:41:19 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, dmitry.torokhov@gmail.com
Subject: BUG: 2.6.20 atkbd spams console after kernel panic
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel panic is my fault, but I'd still like to see the on-screen
messages when it happens.

Unfortunately, 2.6.20 atkbd.c continuously spams the console after a
kernel panic (my fault), with these messages:

...
kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
...

These appear to be getting generated in response to the flashing of the keyboard LEDs
in response to the kernel panic.

Could somebody fix this please?

Cheers
--
Mark Lord
