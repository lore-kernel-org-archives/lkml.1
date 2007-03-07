Return-Path: <linux-kernel-owner+w=401wt.eu-S965518AbXCGUD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965518AbXCGUD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965560AbXCGUD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:03:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965518AbXCGUD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:03:57 -0500
Message-ID: <45EF1AAB.40104@redhat.com>
Date: Wed, 07 Mar 2007 15:03:55 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: PS/2 mouse port missing with kernel >=2.6.19, Sis chipset
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have multiple reports of PS/2 mouse port not being found
on Sis 630 and 730 chipsets, starting with Fedora kernel 2.6.19:

2.6.18:
Jan 19 08:59:39 mtranch kernel: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M]
at 0x60,0x64 irq 1,12
Jan 19 08:59:39 mtranch kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Jan 19 08:59:39 mtranch kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Jan 19 08:59:39 mtranch kernel: mice: PS/2 mouse device common for all mice

2.6.19:
Jan 20 09:22:30 mtranch kernel: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M]
at 0x60,0x64 irq 1,12
Jan 20 09:22:30 mtranch kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Jan 20 09:22:30 mtranch kernel: mice: PS/2 mouse device common for all mice

I'm pretty sure Fedora doesn't patch any input code, so I wonder
if some change was made here that could cause this?
