Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYBLWB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYBLWB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYBLWBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:01:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:39894 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbYBLWBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:01:15 -0500
Subject: Re: [PATCH 00/18] ide: warm-plug support for IDE devices and other
	goodies
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20080212214137.47478e5e@core>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
	 <1202460043.7079.157.camel@pasglop> <1202850247.7410.24.camel@pasglop>
	 <20080212214137.47478e5e@core>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 09:00:40 +1100
Message-Id: <1202853640.7410.31.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-12 at 21:41 +0000, Alan Cox wrote:
> On Wed, 13 Feb 2008 08:04:07 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > 
> > On Fri, 2008-02-08 at 19:40 +1100, Benjamin Herrenschmidt wrote:
> > > On Fri, 2008-02-08 at 01:44 +0100, Bartlomiej Zolnierkiewicz wrote:
> > > > - couple of fixes and preparatory patches
> > > > 
> > > > - rework of PowerMac media-bay support ([un]register IDE devices instead of
> > > >   [un]registering IDE interface) [ it is the main reason for spamming PPC ML ]
> > > 
> > > Interesting... I was thinking about doing a full remove of the device at
> > > a higher level instead but I suppose what you propose is easier.
> > > 
> > > I'll have a look & test next week hopefully.
> > 
> > Also, the above would have the advantage of not relying on drivers/ide
> > infrastructure, and thus working with libata (once somebody has ported
> > pmac ide to libata).
> 
> Unfortunately you need a degree in dentistry to open a Macintosh up and
> fix it otherwise we would have support by now.

Heh :-)

Recent powermacs are trivial to open ! But yeah, I do need to produce a
driver for libata one of these days. On my todo list ...

Cheers,
Ben.


