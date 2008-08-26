Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbYHZNUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbYHZNUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 09:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYHZNTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 09:19:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56674 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbYHZNTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 09:19:52 -0400
Date: Tue, 26 Aug 2008 14:19:32 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: Claudio Scordino <claudio@evidence.eu.com>, lg@denx.de,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ARM] Regression ? at91rm9200 machine-type
Message-ID: <20080826131932.GA24119@flint.arm.linux.org.uk>
References: <48B3DB29.5070409@evidence.eu.com> <200808261443.12638.marc.pignat@hevs.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808261443.12638.marc.pignat@hevs.ch>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 02:43:12PM +0200, Marc Pignat wrote:
> > After commit
> > 
> > 87fee013a23ad02821699aef5b76891b42959182
> > 
> > [ARM] 4647/1: at91rm9200: Remove redundant machine-type verification
> > and manipulation
> > 
> > I cannot boot my board anymore.
> > 
> > Some more details:
> >   - I tried booting from both U-Boot 1.1.6 and U-Boot 1.3.4
> >   - I compiled U-Boot using "at91rm9200dk_config"
> >   - On U-Boot bootargs=console=ttyS0,115200 mem=32M
> > mtdparts=AT45DB642.spi0:-(filesystem) rootfstype=jffs2 root=/dev/mtdblock0
> >   - The .config of the kernel is in attachment
> > 
> > I don't know if this is an actual regression or not (I'm not much
> > skilled in machine-types/boot process).

Thankfully, the recent uboot versions now allow the ID passed to be
configurable via its scripts, rather than being compiled in, so this
means compile time mistakes can be easily corrected without reflashing
the boot loader.  I'm not involved with uboot at all, so I couldn't
tell you which versions are what.

But everything Marc says in his reply is correct.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
