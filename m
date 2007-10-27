Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbXJ0PPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbXJ0PPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 11:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXJ0PPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 11:15:13 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52544 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbXJ0PPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 11:15:12 -0400
Date: Sat, 27 Oct 2007 17:15:11 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Gabriel C <nix.or.die@googlemail.com>
cc: perex@perex.cz, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: snd-rtctimer bugs ?
In-Reply-To: <472353E8.4030107@googlemail.com>
Message-ID: <Pine.LNX.4.64.0710271713390.30465@fbirervta.pbzchgretzou.qr>
References: <472353E8.4030107@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 27 2007 17:06, Gabriel C wrote:
>
>sudo modprobe snd-rtctimer
>WARNING: Error inserting rtc (/lib/modules/2.6.24-rc1-gec3b67c1/kernel/drivers/char/rtc.ko): Input/output error
>FATAL: Error inserting snd_rtctimer (/lib/modules/2.6.24-rc1-gec3b67c1/kernel/sound/core/snd-rtctimer.ko): Unknown symbol in module, or unknown parameter (see dmesg)                                                                                     
>
>from dmesg :
>
>[ 4103.462367] rtc: I/O resource 70 is not free.
>[ 4103.477605] snd_rtctimer: Unknown symbol rtc_register
>[ 4103.477780] snd_rtctimer: Unknown symbol rtc_unregister
>[ 4103.477900] snd_rtctimer: Unknown symbol rtc_control

http://lkml.org/lkml/2007/1/5/153
