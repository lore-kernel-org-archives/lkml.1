Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbYISPda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbYISPda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYISPdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:33:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56475 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750722AbYISPdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:33:21 -0400
Date: Fri, 19 Sep 2008 16:28:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: "Timur Tabi" <timur@freescale.com>,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Dan Williams" <dan.j.williams@intel.com>,
       "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
Message-ID: <20080919162853.773f1796@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.61.0809191042020.11905@chaos.analogic.com>
References: <48D02589.8070601@freescale.com>
	<e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com>
	<ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com>
	<20080918162826.3a9d9429@hskinnemo-gx745.norway.atmel.com>
	<48D2664D.7040204@freescale.com>
	<20080918164535.5e9f77a8@hskinnemo-gx745.norway.atmel.com>
	<e9c3a7c20809182120r5e056dd7h170959dc1171af84@mail.gmail.com>
	<20080919132544.533ab7d0@hskinnemo-gx745.norway.atmel.com>
	<48D3B880.3070607@freescale.com>
	<Pine.LNX.4.61.0809191042020.11905@chaos.analogic.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I could use this feature.  The sound drivers for our MPC8610 processor use DMA,
> > but the drivers need to control the DMA hardware directly, so I can't use
> > dmaengine.  I would like to be able to just reserve the channels and program
> > them as I see fit.


> The hardware on the PC/AT machines won't allow you to
> reserve a specific channel and program it as you see fit,

And since when have MPC8610 processors been used in PC/AT systems ?

PC type ISA DMA is a special (mostly PC specific) interface of its own.

Alan
