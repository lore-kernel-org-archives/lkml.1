Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYGHHOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYGHHOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYGHHOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:14:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49030 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751646AbYGHHOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:14:12 -0400
Date: Tue, 8 Jul 2008 07:41:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, mchan@broadcom.com,
       dwmw2@infradead.org, bastian@waldi.eu.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2 - use request_firmware()
Message-ID: <20080708074132.7d403e98@the-village.bc.nu>
In-Reply-To: <487293F8.30405@garzik.org>
References: <C27F8246C663564A84BB7AB34397724201E1494B50@IRVEXCHCCR01.corp.ad.broadcom.com>
	<1215421413.3189.199.camel@shinybook.infradead.org>
	<1215456981.5532.20.camel@dell>
	<20080707.143803.99767036.davem@davemloft.net>
	<20080707221950.3dfba435@the-village.bc.nu>
	<487293F8.30405@garzik.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jul 2008 18:08:56 -0400
> > Not shipping lots of copies
> > Not leaving crap locked in kernel memory when it isn't needed
> > Letting vendors issue firmware updates (which especially in enterprise
> > space is a big issue and right now gets messy with compiled in firmware)
> 
> Do these benefits justify the removal of an actively used feature, one 
> more reliable than its replacement?

I think they do for a lot of drivers. And I dispute the actively used
feature claim except for a tiny number of people.
> 
> >> I think it is, in fact, the driver maintainer's perogative of whether
> >> they want request_firmware() to be supported by their driver or not.
> >> It is they who have to deal with any possible fallout.
> > 
> > And their users and the distributors for whom it can cause enormous pain.
> 
> Where is this enormous pain associated with tg3's compiled-in firmware? 
>   It's been quite convenient.

How many kernel updates do you think all the worlds users and
distributors have transferred. How much bandwidth and time do you think
that cost ?

Alan
