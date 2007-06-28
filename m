Return-Path: <linux-kernel-owner+w=401wt.eu-S1763396AbXF1LfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763396AbXF1LfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 07:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758701AbXF1Lew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 07:34:52 -0400
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:33426 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758427AbXF1Lev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 07:34:51 -0400
Date: Thu, 28 Jun 2007 13:34:46 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Adrian Bunk <bunk@stusta.de>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, david@lang.hm,
       linux-arch@vger.kernel.org
Subject: Re: Userspace compiler support of "long long"
In-Reply-To: <Pine.LNX.4.64.0706280844030.22579@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0706281333320.24833@anakin>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
 <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
 <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de>
 <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com> <20070627154046.GN1094@stusta.de>
 <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de>
 <20070627173240.GR1094@stusta.de> <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com>
 <20070627155715.60ebc48f.randy.dunlap@oracle.com>
 <20070627161648.52d3786d.randy.dunlap@oracle.com> <Pine.LNX.4.64.0706280411520.26289@anakin>
 <Pine.LNX.4.64.0706280844030.22579@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Jan Engelhardt wrote:
> On Jun 28 2007 04:12, Geert Uytterhoeven wrote:
> >On Wed, 27 Jun 2007, Randy Dunlap wrote:
> >> On Wed, 27 Jun 2007 15:57:15 -0700 Randy Dunlap wrote:
> >> > LDD3 ch. 11 says that long on Sparc64 is 32 bits.
> >> > Same for "ppc" (don't know which power* arch. they mean by that).
> >> 
> >> Hm, I suppose that table only applies to userspace, not kernel...
> >
> >32-bit userspace?
> >
> >On 64-bit, `long' is 64-bit on all platforms supported by Linux.
> 
> All types are as wide as the compiler makes them.
> 
> Compiler  short  int long llong
> Turbo C      16   16   32     -
> GCC -m32     16   32   32    64
> GCC -m64     16   32   64    64

We do not support building Linux with Turbo C (or MS Visual C for Win64
P64).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
