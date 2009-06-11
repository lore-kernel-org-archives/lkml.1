Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbZFKMlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbZFKMlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZFKMli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:41:38 -0400
Received: from woodchuck.wormnet.eu ([77.75.105.223]:47507 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbZFKMlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:41:37 -0400
Date: Thu, 11 Jun 2009 13:41:39 +0100
From: Alexander Clouter <alex@digriz.org.uk>
To: linux-serial@vger.kernel.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] 8250: add Texas Instruments AR7 internal UART
Message-ID: <20090611124139.GI2014@woodchuck>
References: <200906041622.47591.florian@openwrt.org> <20090604222020.GA14843@alpha.franken.de> <200906111028.41222.florian@openwrt.org> <20090611093022.GA14510@alpha.franken.de> <n967g6-i6b.ln1@woodchuck.wormnet.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n967g6-i6b.ln1@woodchuck.wormnet.eu>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Alexander Clouter <alex@digriz.org.uk> [2009-06-11 12:27:19+0100]:
> 
> > static struct plat_serial8250_port uart0_data = {
> >        .mapbase = AR7_REGS_UART0,
> >        .irq = AR7_IRQ_UART0,
> >        .regshift = 2,
> >        .iotype = UPIO_MEM,
> >        .flags = UPF_BOOT_AUTOCONF | UPF_IOREMAP,
> > };
> > 
> >        uart_port[0].type = PORT_16550A;
> >        uart_port[0].line = 0;
> >        uart_port[0].irq = AR7_IRQ_UART0;
> >        uart_port[0].uartclk = ar7_bus_freq() / 2;
> >        uart_port[0].iotype = UPIO_MEM;
> >        uart_port[0].mapbase = AR7_REGS_UART0 + 3;
> >        uart_port[0].membase = ioremap(uart_port[0].mapbase, 256);
> >        uart_port[0].regshift = 2;
> >        res = early_serial_setup(&uart_port[0]);
> >        if (res)
> >                return res;
> > 
> > 
> > the +3 comes from the fact, that this machine is configured to run big
> > endian.
> >
> Alternatively you could not use the byte ordering macro/functions as per 
> the 'Byte Order' section in:
> 
> http://lwn.net/images/pdf/LDD3/ch11.pdf
> 
> Makes the code portable, understandable and...well neater.
> 
Maybe not, scrap that :)

Cheers

-- 
Alexander Clouter
.sigmonster says: "MOKE DAT YIGARETTE"
                  		-- "The Last Coin", James P. Blaylock
