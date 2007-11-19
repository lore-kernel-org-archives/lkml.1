Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbXKSTzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbXKSTzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbXKSTzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:55:31 -0500
Received: from gate.crashing.org ([63.228.1.57]:33169 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbXKSTza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:55:30 -0500
Subject: Re: SCSI breakage on non-cache coherent architectures
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <1195484964.3283.4.camel@localhost.localdomain>
References: <1195450523.7022.37.camel@pasglop>
	 <20071119123240.GA12494@parisc-linux.org>
	 <1195484964.3283.4.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 06:55:16 +1100
Message-Id: <1195502116.6970.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I'd like to be rid of it inside the command for various reasons:  every
> command has one of these, and they're expensive in the allocation (at 96
> bytes).  There's no reason we have to allocate and free that amount of
> space with every command.  In theory, the number of these is bounded at
> the queue depth, in practice, there's usually only one, and this DMA
> alignment issue does requires most drivers to double copy.

Do you have a plan for short term here ? I'd like something fixed
for .25, so I may have to introduce a __dma_aligned macro of some sort
to deal with that in the meantime...

Ben.


