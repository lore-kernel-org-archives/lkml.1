Return-Path: <linux-kernel-owner+w=401wt.eu-S1760617AbYGCNeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617AbYGCNeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759532AbYGCNdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:33:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60693 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759506AbYGCNdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:33:41 -0400
Date: Thu, 3 Jul 2008 14:32:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sedji Gaouaou <sedji.gaouaou@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       VILCHEZ Patrice <Patrice.VILCHEZ@atmel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Support for the at91sam9g20 : Atmel 400Mhz ARM 926ej-s SOC
Message-ID: <20080703133244.GB17201@flint.arm.linux.org.uk>
References: <4852324C.9000604@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4852324C.9000604@atmel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 10:39:40AM +0200, Sedji Gaouaou wrote:
> Support for the at91sam9g20 : Atmel 400Mhz ARM 926ej-s SOC.
> 
> At91sam9g20 is an evolution of the at91sam9260 with a faster clock speed.
> We created a new board for this device but based the chip support directly
> on 9260 files with little updates.
> Here is the chip page on Atmel website :
> http://atmel.com/dyn/products/product_card.asp?part_id=4337

I'm not sure what's going on, but the patch submitted to the patch system
is different from the one in this message.  The patch in your message
applies to my 'at91' branch just fine.  The one in the patch system
doesn't.

Plus, the description in the patch system is way too long in terms of
line length.  Please wrap before column 72 unless you're quoting
program output.

> +/*
> + * MCI (SD/MMC)
> + */
> +static struct at91_mmc_data __initdata ek_mmc_data = {
> +	.slot_b		= 1,
> +	.wire4		= 1,
> +//	.det_pin	= ... not connected
> +//	.wp_pin		= ... not connected
> +//	.vcc_pin	= ... not connected

Please make these a proper comment, preferably inside the comment before
the structure.  C++ comments are frowned upon in the kernel's source.
