Return-Path: <linux-kernel-owner+w=401wt.eu-S1764515AbYBTAwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764515AbYBTAwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbYBTAwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:52:15 -0500
Received: from gate.crashing.org ([63.228.1.57]:59593 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbYBTAwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:52:13 -0500
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] fb: add support for foreign
	endianness
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Clemens Koller <clemens.koller@anagramm.de>,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       Krzysztof Helt <krzysztof.h1@poczta.fm>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <28238.1203468428@turing-police.cc.vt.edu>
References: <20080205154432.GA8749@localhost.localdomain>
	 <20080214224942.a0cb6218.akpm@linux-foundation.org>
	 <20080215164542.GB16810@localhost.localdomain>
	 <Pine.LNX.4.64.0802171030330.6848@anakin>
	 <20080218081847.e9e65f2f.krzysztof.h1@poczta.fm>
	 <19805.1203355811@turing-police.cc.vt.edu> <47BA162C.5000807@anagramm.de>
	 <1203381353.6740.59.camel@pasglop> <47BABD3A.7010102@anagramm.de>
	 <20080219040530.7b1d115d.akpm@linux-foundation.org>
	 <28238.1203468428@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 11:50:04 +1100
Message-Id: <1203468604.7273.7.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-19 at 19:47 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 19 Feb 2008 04:05:30 PST, Andrew Morton said:
> > On Tue, 19 Feb 2008 12:27:54 +0100 Clemens Koller <clemens.koller@anagramm.de
> > wrote:
> > > That's not an issue in my case. The SM50x can be connected to
> > > either an PCI or some Local/CPU-whateverbus IF.
> > > I.e. on the MPC85xx PowerPC, PCI and LocalBus are separate bussses.
> > > If the sm501 is attached to the MPC85xx' PCI like any other video card,
> > > the PCI config-space is can be accessed as usual, whereas the framebuffer
> > > memory area is byte-swapped compared to other common video cards.
> 
> > Anyway, my head is now officially spinning.  Did anyone actually have a
> > reason why we shouldn't proceed with Anton's patch?
> 
> Clemens answered my question regarding the real-life existence of hardware
> that would benefit.  I'd say if Anton's patch works on Clemens' hardware and
> otherwise passes review, we should proceed...

No objection here neither.

Ben.


