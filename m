Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbYKTGU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbYKTGU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 01:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYKTGUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 01:20:49 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:23817 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbYKTGUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 01:20:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WpJScPeX8hB7U49ADcF9lnqc651xBmQyT0eDR/CLjKTl3PduhiB6KySPcjan6RUY56
         0FSzBZ/zMNQEaL53FyrA4QzJjZbRwXqK7Q7QmUeIb3LrAuQy1R49IcdMvakfvNmE/L3K
         hNSHw0ZxDJJGcl5Lo3/HB8hHa/sv6W+nvC1ks=
Message-ID: <b0c88b10811192220s7a61f1eax2dfc84e935a7a05a@mail.gmail.com>
Date: Thu, 20 Nov 2008 07:20:46 +0100
From: "Antonio R. Costa" <costa.antonior@gmail.com>
To: "Linux Kernel list" <linux-kernel@vger.kernel.org>
Subject: Fwd: [PATCH] mmc: atmel-mci: move atmel-mci.h file to include/linux
In-Reply-To: <b0c88b10811192207oe65e02fg91ec6476b49564ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491C0C05.6040301@atmel.com> <20081113134818.GA9161@fluff.org.uk>
	 <491C3D16.1050501@atmel.com>
	 <20081119193631.448ae25e@mjolnir.drzeus.cx>
	 <b0c88b10811192207oe65e02fg91ec6476b49564ba@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
  I agree with Pierre.

I find pretty confusing to mix protocol .h file with drver specific includes.
Why can't we have something like:

include/linux/mmc
include/drivers/mmc

Ciao,
Antnoio

2008/11/19 Pierre Ossman <drzeus@drzeus.cx>
>
> On Thu, 13 Nov 2008 15:43:34 +0100
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>
> > Ben Dooks :
> > >
> > > Would people object to putting this in include/linux/mmc/atmel.h
> > > to avoid making include/linux abound with device/subsystem/machine
> > > specific header files?
> >
> > I tend to agree *but* it seems that header files in include/linux/mmc
> > are mostly sd/mmc subsystem core files (I mean, not driver ones).
> > Although, a bunch of atmel-a_driver.h files are already in include/linux...
> >
> > Pierre, a comment ?
> >
>
> I'd prefer if include/linux/mmc could stay clean and just have core
> stuff since the header files are basically the reference documentation
> for the subsystem. But if you can't find any other way...
>
> --
>     -- Pierre Ossman
>
>  WARNING: This correspondence is being monitored by the
>  Swedish government. Make sure your server uses encryption
>  for SMTP traffic and consider using PGP for end-to-end
>  encryption.
