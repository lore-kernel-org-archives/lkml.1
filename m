Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbZFBItw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbZFBItw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbZFBIto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:49:44 -0400
Received: from mail.atmel.fr ([81.80.104.162]:56438 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776AbZFBIto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:49:44 -0400
Message-ID: <4A24E788.2090305@atmel.com>
Date: Tue, 02 Jun 2009 10:49:12 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rob Emanuele <poorarm@shoreis.com>
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] New AT91 MCI Driver that supports both MCI slots used
 at the 	same time
References: <c8284b5b0905281440hd2e4993re3d0d8c590713fa0@mail.gmail.com>
In-Reply-To: <c8284b5b0905281440hd2e4993re3d0d8c590713fa0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Emanuele :
> Greetings,
> 
> This patch creates a new AT91 Multimedia Card Interface (MCI) driver
> that supports using both MCI slots at the same time.  I'm looking for
> others to test this patch on other boards within the same family of
> chips.
> 
> This driver is a port the Atmel AVR32 MCI driver which uses similar silicon.

I am very interested with this work. But, you will have to tell us what
is the precise relation between this code and the Atmel AVR32 MCI driver.
Why did you rename all function and variables to at91... instead of
trying to modify the atmel-mci driver ? Was the needed behavior so far
from the original code that you decided to create another completely new
one ? Please enlighten us.

Moreover, it seems that in your code, DMA is not supported so atmel-mci
without the DMA option enabled should be working without modification at
all (am I missing something ?).

> In addition it modifies the AT91SAM9G20-EK's board platform config to
> support having MCI Slot A hooked to an SD Slot.  This was the board
> that this was developed on. To support MCI Slot A it was needed to not
> enable the LEDs on the AT91SAM9G20-EK board if SD/MMC Slot A is
> enabled.  The Slot A pins overlap the LEDs on Rev A and B boards.

This is a different board, so you will have to create a different board
source file (board-my9g20customboard.c) or find a clever way of sharing
code (true, can be preferable as only a few lines are changing).

Best regards,
-- 
Nicolas Ferre

