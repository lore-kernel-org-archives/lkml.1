Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbXGaXqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbXGaXqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbXGaXqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:46:00 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50912 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756715AbXGaXp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:45:59 -0400
Date: Wed, 1 Aug 2007 00:53:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
Cc: Jaroslav Kysela <perex@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CS5530 Alsa driver fails
Message-ID: <20070801005310.1ef01458@the-village.bc.nu>
In-Reply-To: <46AFC017.8090805@interia.pl>
References: <46AFC017.8090805@interia.pl>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> After "modprobe snd-cs5530" I have:
> CS5530: XpressAudio at 0x220
> CS5530: MPU at 0x330
> CS5530: IRQ: 9 DMA8: 0 DMA16: 5
> sb: can't grab irq 9
> CS5530: Could not create SoundBlaster
> CS5530_Audio: probe of 0000:00:12.3 failed with error -16

Might be worth setting the IRQ to sharable. I've never seen a 5530 with
the sound IRQ shared so I don't know if that works and is a valid
configuration for the VSA firmware
