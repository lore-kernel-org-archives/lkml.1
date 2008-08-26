Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYHZMnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYHZMnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 08:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYHZMnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 08:43:16 -0400
Received: from mail.hevs.ch ([153.109.23.10]:46773 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbYHZMnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 08:43:15 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Claudio Scordino <claudio@evidence.eu.com>
Subject: Re: [ARM] Regression ? at91rm9200 machine-type
Date: Tue, 26 Aug 2008 14:43:12 +0200
User-Agent: KMail/1.9.9
Cc: lg@denx.de, rmk+kernel@arm.linux.org.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <48B3DB29.5070409@evidence.eu.com>
In-Reply-To: <48B3DB29.5070409@evidence.eu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261443.12638.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tuesday 26 August 2008, you wrote:
> Hi,
> 
>     I have a custom board equivalent to AT91RM9200DK.
If it is really equivalent, you can use the same MACH_TYPE, else you should
register another.

> 
> After commit
> 
> 87fee013a23ad02821699aef5b76891b42959182
> 
> [ARM] 4647/1: at91rm9200: Remove redundant machine-type verification
> and manipulation
> 
> I cannot boot my board anymore.
> 
> Some more details:
>   - I tried booting from both U-Boot 1.1.6 and U-Boot 1.3.4
>   - I compiled U-Boot using "at91rm9200dk_config"
>   - On U-Boot bootargs=console=ttyS0,115200 mem=32M
> mtdparts=AT45DB642.spi0:-(filesystem) rootfstype=jffs2 root=/dev/mtdblock0
>   - The .config of the kernel is in attachment
> 
> I don't know if this is an actual regression or not (I'm not much
> skilled in machine-types/boot process).

The "default machine" selection is a *hack* for machines with a bootloader too
old, buggy or closed source.

The right fix is to change the MACH_TYPE that you've compiled in u-boot.

> 
> However, it seems that the commit above, besides removing redundant 
> machine type verification, removed the default machine type for 
> unknown boards as well.

This is a cleanup patch, if the hack is not removed, bootloaders will *never*
be fixed...

Best regards


Marc

