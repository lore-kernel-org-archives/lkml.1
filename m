Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab0CEOwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:52:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58610 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751771Ab0CEOwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:52:40 -0500
Date: Fri, 5 Mar 2010 14:55:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Tate <michael.tate@wanadoo.fr>
Cc: gregkh@suse.de, alan@linux.intel.com, o.hartmann@telovital.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] staging:et131x:et131x_isr.c Fix coding style
 issues. This patch fixes line length and brace coding style issues raised
 by checkpatch.pl Signed-off-by: Michael Tate <michael.tate@wanadoo.fr>
Message-ID: <20100305145523.746491f5@lxorguk.ukuu.org.uk>
In-Reply-To: <1267799456-5949-1-git-send-email-michael.tate@wanadoo.fr>
References: <1267799456-5949-1-git-send-email-michael.tate@wanadoo.fr>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	if (status & ET_INTR_TXDMA_ISR) {
> +	if (status & ET_INTR_TXDMA_ISR)
>  		et131x_handle_send_interrupt(etdev);
> -	}
>  
>  	/* Handle all the completed Receives interrupts */
> -	if (status & ET_INTR_RXDMA_XFR_DONE) {
> +	if (status & ET_INTR_RXDMA_XFR_DONE)
>  		et131x_handle_recv_interrupt(etdev);
> -	}

Plenty of those to kill I am sure. 


>  		/* Handle Free Buffer Ring 0 and 1 Low interrupt */
> -		if (status & (ET_INTR_RXDMA_FB_R0_LOW | ET_INTR_RXDMA_FB_R1_LOW)) {
> +		if (status &
> +			(ET_INTR_RXDMA_FB_R0_LOW | ET_INTR_RXDMA_FB_R1_LOW)) {

Bt gratuitious wrapping of stuff that's quite readable is not an
improvement. (The 80 chars guide in the coding style is just that - and
largely retired)

>  			/*
>  			 * This indicates the number of unused buffers in
>  			 * RXDMA free buffer ring 0 is <= the limit you

You need a Signed-off-by: line for submitting it. See
Documentation/SubmittingPatches for more details if you need to.

Please do resubit the first parts of that patch (and others like it), the
driver still needs a lot of attention and cleaning it up stylewise is
part of that work.

Alan
