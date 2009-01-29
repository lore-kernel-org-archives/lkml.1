Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZA2MnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZA2MnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 07:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZA2MnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 07:43:05 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:39545 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbZA2MnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 07:43:03 -0500
Date: Thu, 29 Jan 2009 13:43:02 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Pazzo Da Legare <pazzodalegare@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: how to change serial device<->port association
In-Reply-To: <1a26b4920901290302w5c9bb79cra29fda5e67cc96a4@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.0901291342050.15159@fbirervta.pbzchgretzou.qr>
References: <1a26b4920901290302w5c9bb79cra29fda5e67cc96a4@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2009-01-29 12:02, Pazzo Da Legare wrote:

>Dear ML,
>
>how can I instruct the kernel (if possible) to map a certain serial
>port to a specific device ttySx?
>I have 4 16550 ports and kernel ( the driver, I suppose) say to me:
>
>Serial: 8250/16550 driver $Revision: 1.90 $ 6 ports, IRQ sharing disabled
>serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
>serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a NS16550A
>serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a NS16550A
>00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
>00:0b: ttyS2 at I/O 0x3e8 (irq = 10) is a NS16550A
>00:0c: ttyS3 at I/O 0x2e8 (irq = 11) is a NS16550A
>
>I would like to change the map ttySx -> I/O port. I try with setserial
>but it doesn't work....Any clue?

If you want to access ttyS4, etc. you need to increase
CONFIG_SERIAL_8250_NR_UARTS. I found that using setserial(8)
to change ports for an existing ttyS[0-3] has no effects.
