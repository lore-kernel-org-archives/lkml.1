Return-Path: <linux-kernel-owner+w=401wt.eu-S936663AbXGQUvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936663AbXGQUvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933968AbXGQUsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:48:40 -0400
Received: from smtpq3.groni1.gr.home.nl ([213.51.130.202]:37518 "EHLO
	smtpq3.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933978AbXGQUsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:48:38 -0400
Message-ID: <469D2AE5.2080204@gmail.com>
Date: Tue, 17 Jul 2007 22:47:33 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: mike@pikeaero.com
CC: linux-kernel@vger.kernel.org
Subject: Re: maintainer: parport drivers
References: <1184688556.711.8.camel@jake>
In-Reply-To: <1184688556.711.8.camel@jake>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2007 06:09 PM, Mike Sharkey wrote:

> My question is; what are some of the outstanding issues with parport 
> which people would like to see addressed?

I've been wondering why PARPORT_PC_FIFO is EXPERIMENTAL. If it's expected to 
work these days it could be made non-experimental, and perhaps enabled 
always even.

Also not sure of the value of PARPORT_PC_SUPERIO. I haven't checked in some 
time, but that code didn't use to work for me even though I have a chipset 
which seems supported (Winbond 83977). These days, PNP (-ACPI) is providing 
PARPORT with the needed info for me:

| pnp: the driver 'parport_pc' has been registered
| pnp: match found with the PnP device '00:09' and the driver 'parport_pc'
| parport_pc 00:09: reported by Plug and Play ACPI
| parport0: PC-style at 0x378 (0x778), irq 7, dma 3 
[PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
| lp0: using parport0 (interrupt-driven).

If that's also expected, perhaps that option and code could just go...

Rene.
