Return-Path: <linux-kernel-owner+w=401wt.eu-S932922AbXBFRbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbXBFRbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 12:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932999AbXBFRbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 12:31:24 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56714 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932922AbXBFRbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 12:31:23 -0500
Date: Tue, 6 Feb 2007 17:44:28 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Levitsky Maxim <maximlevitsky@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question: Status of marvell's PATA 88SE6101 controller on intel
 boards
Message-ID: <20070206174428.7ca93476@localhost.localdomain>
In-Reply-To: <508716.76088.qm@web38507.mail.mud.yahoo.com>
References: <508716.76088.qm@web38507.mail.mud.yahoo.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I also noticed that 2.6.20 adds experimentally support for that chip.
> But driver says that it enables it via 'legacy mode'

Yes.

> I will be glad to hear whenever full support is planned or not.

At the moment it is not, but it may be a neccessary side effect of full
support for the later SATA capable controllers in native SATA mode. In
which case you might get it one day.

The legacy mode is itself as good as most typical PATA controllers and
better than some.
>
> And as last thing I want to ask you whenever current support is usable, 
> that is can I use DMA , can I use DVD as at least reader for CD/DVD , 
> and even better can I burn disks with it ( although I can live without it)

The legacy mode has full DMA support. What you don't get is the ability
to queue multiple commands so the hardware can fire off a new command as
the first completes and to have the hardware do some of the general
poking around for us. 

Alan
