Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbXKVCOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbXKVCOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 21:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXKVCOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 21:14:24 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:40306 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbXKVCOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 21:14:23 -0500
Date: Wed, 21 Nov 2007 21:14:22 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Niessner <Al.Niessner@jpl.nasa.gov>, linux-kernel@vger.kernel.org
Subject: Re: Where is the interrupt going?
Message-ID: <20071122021422.GA9265@fattire.cabal.ca>
References: <1195693710.5544.240.camel@morte.jpl.nasa.gov> <20071122015625.0e33acfc@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122015625.0e33acfc@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 01:56:25AM +0000, Alan Cox wrote:
> > status = request_irq (apcsi[i].board_irq,
> >                                       apc8620_handler,
> >                                       IRQF_DISABLED,
> 
> You set IRQF_DISABLED
> 
> Do you then enable the interrupt anywhere later on ?
> 

IRQF_DISABLED just means that the handler is atomic wrt other local
interrupts. Shouldn't be the cause of this.

cheers,
	Kyle
