Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbXKSTH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbXKSTH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbXKSTHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:07:19 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:53282 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbXKSTHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:07:18 -0500
Date: Mon, 19 Nov 2007 20:07:12 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Bill Gribble <grib@billgribble.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2 libertas_sdio fails to initialize Marvell SD8686
Message-ID: <20071119200712.7b0295d3@poseidon.drzeus.cx>
In-Reply-To: <87ejernrqo.fsf@serrano.home.billgribble.com>
References: <87bq9x264q.fsf@serrano.home.billgribble.com>
 <20071114190247.4f42aa05@poseidon.drzeus.cx>
 <87ejernrqo.fsf@serrano.home.billgribble.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 16:06:23 -0500
Bill Gribble <grib@billgribble.com> wrote:

> 
> This block gets repeated about 200 times: 
> 
> Nov 15 11:52:31 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
> Nov 15 11:52:31 pequin kernel: mmc0: req done (CMD52): 0: 00001000 00000000 00000000 00000000
> Nov 15 11:52:31 pequin kernel: mmc0: starting CMD52 arg 10002000 flags 00000195
> 
> Then:
> 
> Nov 15 11:52:32 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
> Nov 15 11:52:32 pequin kernel: mmc0: req done (CMD52): 0: 00001000 00000000 00000000 00000000
> Nov 15 11:52:32 pequin kernel: mmc0: starting CMD52 arg 80022201 flags 00000195
> Nov 15 11:52:32 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
> Nov 15 11:52:32 pequin kernel: mmc0: req done (CMD52): 0: 00001001 00000000 00000000 00000000
> Nov 15 11:52:32 pequin kernel: libertas: failed to load helper firmware
> 
> Does that make any sense?  
> 

Odd. I'd guess it is waiting for the firmware to boot, bu you should be getting the debug string "waiting for helper to boot..." in that case.

Have you tried with the firmware that's supposed to be used with this board?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
