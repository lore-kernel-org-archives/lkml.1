Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbYBRUi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbYBRUi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYBRUiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:38:20 -0500
Received: from www.tglx.de ([62.245.132.106]:58308 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbYBRUiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:38:19 -0500
Date: Mon, 18 Feb 2008 21:37:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [BUG][RFC] [GENERIC IRQ] irq_chip_set_defaults shutdown /
 disable
In-Reply-To: <600D5CB4DFD93545BF61FF01473D11AC125CC53A@limkexm2.ad.analog.com>
Message-ID: <alpine.LFD.1.00.0802182135580.7583@apollo.tec.linutronix.de>
References: <600D5CB4DFD93545BF61FF01473D11AC125CC53A@limkexm2.ad.analog.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008, Hennerich, Michael wrote:
> >The patch below fixes the shutdown case and keeps the delayed disable
> >logic intact.
>
> >How did you notice ? I guess you got spurious interrupts after calling
> >free_irq(), right ?
> 
> Exactly

Can you please confirm, whether my version of the fix works for you as
well.

Thanks,

	tglx
