Return-Path: <linux-kernel-owner+w=401wt.eu-S1765667AbXGaQUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765667AbXGaQUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760934AbXGaQT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:19:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:43538 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292AbXGaQT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:19:56 -0400
In-Reply-To: <11854393733580-git-send-email-wei.zhang@freescale.com>
References: <11854393721520-git-send-email-wei.zhang@freescale.com> <11854393733580-git-send-email-wei.zhang@freescale.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <14098723940361a2b58ccd251a381f11@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, galak@kernel.crashing.org,
       mporter@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/5 v3] Add the explanation and a sample of RapidIO OF node to the document of booting-without-of.txt file.
Date: Tue, 31 Jul 2007 18:19:44 +0200
To: Zhang Wei <wei.zhang@freescale.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +   l) RapidIO

"FSL PowerPC bridge RapidIO" or something like that -- you
aren't doing a _generic_ rapidio binding here.

> +   RapidIO is a definition of a system interconnect. This node add
> +   the support for RapidIO processor in kernel. The node name is
> +   suggested to be 'rapidio'.
> +
> +   Required properties:
> +
> +    - compatible : Using "fsl,rapidio-delta" for Freescale PowerPC
> +      RapidIO controller.
> +    - #address-cells : Address representation for "rapidio" devices.
> +      This field represents the number of cells needed to represent
> +      the RapidIO address of the registers.
> +      See 1) above for more details on defining #address-cells.
> +    - reg : Offset and length of the register set for the device
> +    - ranges : Should be defined as specified in 1) to describe the
> +      translation of addresses for memory mapped RapidIO memory
> +      space.
> +    - interrupts : binding interrupts for this device node,
> +      please follow below orders:
> +      <err_irq bell_outb_irq bell_inb_irq msg1_tx_irq msg1_rx_irq
> +      msg2_tx_irq msg2_rx_irq ... msgN_tx_irq msgN_rx_irq>.

_All_ of these are "as specified in 1)".  You should be saying
the specifics for your device here; for example, what register
blocks of your controller are described in "reg", and in what
order?


Segher

