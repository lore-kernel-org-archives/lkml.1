Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbYFEOWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbYFEOWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbYFEOWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:22:24 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:55760 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbYFEOWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:22:23 -0400
Date: Thu, 5 Jun 2008 16:22:06 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Geoffrey Wossum <geoffrey@pager.net>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: AT32 ASoC Driver Patches on alsa-devel
Message-ID: <20080605162206.0a34a54e@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200806050851.47319.geoffrey@pager.net>
References: <200806050851.47319.geoffrey@pager.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2008 14:21:31.0068 (UTC) FILETIME=[732EC7C0:01C8C717]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geoffrey Wossum <geoffrey@pager.net> wrote:
> For anyone that's interested, there's patches to add ALSA System-on-Chip sound 
> platform drivers for the AVR32 being discussed on the alsa-devel mailing list 
> right now.

Hmm. For something that depends on a metric shitload of middle layers,
it is surprisingly large...

I have to admit I don't understand the current sound situation at all.
With this driver, we now have:
  * An OSS driver for the AP7000 Audio Bitstream DAC
  * A "regular" ALSA driver for the AC97C (not based on ASoC)
  * Two different "generic" AC97 layers: one in sound/pci/ac97 and one
    in sound/soc/ac97 (the AC97C driver uses the former)
  * An i2s driver for the AT73C213 chip using the SSC controller and SPI
  * Another SSC driver based on the ASoC layer
  * Some sort of "AT32 PCM" layer which apparently can only be used
    with the SSC controller
  * The above two being essentially identical to similar drivers for
    AT91

Can someone please help me out here? In particular, what is ASoC and
why should I want to use it?

Haavard
