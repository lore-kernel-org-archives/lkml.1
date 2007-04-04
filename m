Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbXDDNn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbXDDNn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 09:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbXDDNn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 09:43:28 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:3785 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbXDDNn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 09:43:27 -0400
Date: Wed, 4 Apr 2007 14:43:19 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: David Miller <davem@davemloft.net>, dwmw2@infradead.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <Pine.LNX.4.64.0704040903470.20803@anakin>
Message-ID: <Pine.LNX.4.64N.0704041436130.19559@blysk.ds.pg.gda.pl>
References: <20070404022544.59b022a6@the-village.bc.nu>
 <17939.10130.687893.167511@cargo.ozlabs.ibm.com> <1175663999.2932.8.camel@shinybook.infradead.org>
 <20070403.225006.119275067.davem@davemloft.net> <Pine.LNX.4.64.0704040903470.20803@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Geert Uytterhoeven wrote:

> > > I don't see why that 'should' be the case. Certainly it _isn't_ the case
> > > on most supported platforms -- we have separate device numbers, and
> > > names, for most types of ports. There's only one or two drivers which
> > > abuse ttySn for anything other than 8250 ports.
> > 
> > sunsu, sunzilog, pmac_zilog, sunsab, etc.
> 
> amiserial.
> 
> > The list is longer than you think.  In fact the convention is
> > very well established.
> 
> And I guess the recently revived Atari serial driver, too.

 And also DEC hardware, i.e. zs (which drives Zilog ports too) and dz 
(which handles integrated to the various extent clones of the original 
PDP-11 serial multiplexer ;-) ).

  Maciej
