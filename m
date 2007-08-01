Return-Path: <linux-kernel-owner+w=401wt.eu-S1761988AbXHAMLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761988AbXHAMLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763608AbXHAMLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:11:47 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:13579 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763333AbXHAMLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:11:45 -0400
Message-ID: <46B07877.8060604@interia.pl>
Date: Wed, 01 Aug 2007 14:11:35 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jaroslav Kysela <perex@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CS5530 Alsa driver fails
References: <46AFC017.8090805@interia.pl>	<20070801005310.1ef01458@the-village.bc.nu> <s5hodhrttz1.wl%tiwai@suse.de>
In-Reply-To: <s5hodhrttz1.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: d5964acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Might be worth setting the IRQ to sharable. I've never seen a 5530 with
>> the sound IRQ shared so I don't know if that works and is a valid
>> configuration for the VSA firmware
> 
> The relevant patch is below.  Please give it a try.
> 
> 
> Takashi

> -	if (request_irq(irq, irq_handler, hardware == SB_HW_ALS4000 ?
> +	if (request_irq(irq, irq_handler,
> +			(hardware == SB_HW_ALS4000 ||
> +			 hardware == SB_HW_CS5530) ?

CS5530: XpressAudio at 0x220
CS5530: MPU at 0x330
CS5530: IRQ: 9 DMA8: 0 DMA16: 5
ALSA sound/isa/sb/sb_common.c:91: snd_sbdsp_reset [0x220] failed...
CS5530: Could not create SoundBlaster

Does this mean that interrupt cannot be shared? Or is this something 
worse?

Thanks
Rafa³


----------------------------------------------------------------------
Dowiedz sie, co naprawde podnieca kobiety. Wiecej wiesz, latwiej je
oczarujesz 

>>>http://link.interia.pl/f1b17

