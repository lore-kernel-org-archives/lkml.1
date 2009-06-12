Return-Path: <linux-kernel-owner+w=401wt.eu-S932832AbZFLJ30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbZFLJ30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbZFLJ3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:29:19 -0400
Received: from relay.atmel.no ([80.232.32.139]:58258 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbZFLJ3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:29:18 -0400
Date: Fri, 12 Jun 2009 11:29:00 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Rob Emanuele <poorarm@shoreis.com>, Andrew Victor <avictor.za@gmail.com>,
       Joey Oravec <joravec@drewtech.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Subject: Re: [PATCH][Fix] New Unified AVR32/AT91 MCI Driver that supports
 both 	MCI slots used at the same time
Message-ID: <20090612112900.4435f70f@hskinnemoen-d830>
In-Reply-To: <4A3219F6.6000300@atmel.com>
References: <c8284b5b0906101641v586c3487i465263bb6908e3f7@mail.gmail.com>
	<20090611095432.2e3a4067@hskinnemoen-d830>
	<c8284b5b0906111316p1367a508vdb59ee7c2a8d2ff1@mail.gmail.com>
	<4A3219F6.6000300@atmel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> > Well, what is the best way to differentiate it from the at91_mci
> > driver and keep users from trying to use both drivers?  
> 
> I propose that we setup a kind of choice sub menu in the Kconfig for
> those two drivers when they are both supported.

Shouldn't it be enough to simply add

	depends on !THE_OTHER_DRIVER

to both of them?

Btw, what are the long-term plans for this? Should the at91_mci driver
be phased out once the atmel-mci driver supports all at91 and avr32
devices?

> > Who would that be as I haven't seen anyone who maintains any of those
> > boards other than the at91rm8200 (at least nothing listed in the
> > MAINTAINERS file)?  The board-sam9g20ek.c platform only shows Atmel as
> > the most recent copyright.  
> 
> Hey, AT91 are very well maintained, SAM9 as well as at91rm9200.
> So, AT91 specific bits should be sent to this mailing-list with Andrew
> Victor in copy.
> I will also certainly add comments on this code.

One of you should update MAINTAINERS to reflect this.

Haavard
