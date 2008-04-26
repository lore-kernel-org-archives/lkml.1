Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbYDZSfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbYDZSfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbYDZSfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:35:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756096AbYDZSfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:35:31 -0400
Date: Sat, 26 Apr 2008 11:34:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: Ben Dooks <ben-linux@fluff.org>, Daniel Mack <daniel@caiaq.org>,
       linux-arm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Colibri: Fix support for DM9000 ethernet device.
Message-Id: <20080426113434.2ca4c5b0.akpm@linux-foundation.org>
In-Reply-To: <20080424122203.B52164@saturn.araneidae.co.uk>
References: <20080424095917.Q51356@saturn.araneidae.co.uk>
	<20080424112858.GD16284@fluff.org.uk>
	<20080424122203.B52164@saturn.araneidae.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008 12:24:43 +0000 (GMT) Michael Abbott <michael@araneidae.co.uk> wrote:

> On Thu, 24 Apr 2008, Ben Dooks wrote:
> > On Thu, Apr 24, 2008 at 10:13:09AM +0000, Michael Abbott wrote:
> >> From: Michael Abbott <michael.abbott@diamond.ac.uk>
> >>
> >> Colibri: Fix support for DM9000 ethernet device.
> >> diff --git a/arch/arm/mach-pxa/colibri.c b/arch/arm/mach-pxa/colibri.c
> >> --- a/arch/arm/mach-pxa/colibri.c
> >> +++ b/arch/arm/mach-pxa/colibri.c
> >> @@ -118,7 +118,7 @@ static void __init colibri_init(void)
> >>  	/* DM9000 LAN */
> >>  	pxa_gpio_mode(GPIO78_nCS_2_MD);
> >>  	pxa_gpio_mode(GPIO_DM9000 | GPIO_IN);
> >> -	set_irq_type(COLIBRI_ETH_IRQ, IRQT_FALLING);
> >> +	set_irq_type(COLIBRI_ETH_IRQ, IRQT_RISING);
> >
> > The set_irq_type() call here should be removed.
> 
> I can confirm that Ben is right, and that the set_irq_type call can be 
> removed.
> 
> What is the procedure here?  Do I submit a new patch to supersede the old 
> one?

Yup, that's OK.
