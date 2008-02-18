Return-Path: <linux-kernel-owner+w=401wt.eu-S1761424AbYBRUro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424AbYBRUro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYBRUrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:47:35 -0500
Received: from www.tglx.de ([62.245.132.106]:51478 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbYBRUrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:47:35 -0500
Date: Mon, 18 Feb 2008 21:47:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: RE: [BUG][RFC] [GENERIC IRQ] irq_chip_set_defaults shutdown /
 disable
In-Reply-To: <600D5CB4DFD93545BF61FF01473D11AC125CC53A@limkexm2.ad.analog.com>
Message-ID: <alpine.LFD.1.00.0802182146020.7583@apollo.tec.linutronix.de>
References: <600D5CB4DFD93545BF61FF01473D11AC125CC53A@limkexm2.ad.analog.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008, Hennerich, Michael wrote:
> >From: Thomas Gleixner Montag, 18. Februar 2008 18:49
> >+static void default_shutdown(unsigned int irq)
> >+{
> >+	struct irq_desc *desc = irq_desc + irq;
> >+
> >+	desc->chip->mask(irq);
> >+	desc->status &= ~IRQ_MASKED;

Needs to be |= IRQ_MASKED of course. 

Thanks, Michael for pointing it out.

	tglx
