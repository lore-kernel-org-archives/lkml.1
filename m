Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbYA3HlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbYA3HlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYA3HlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:41:06 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:33197 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbYA3HlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:41:05 -0500
Date: Wed, 30 Jan 2008 08:40:54 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Zan Lynx <zlynx@acm.org>
cc: Jon Masters <jonathan@jonmasters.org>, Pavel Roskin <proski@gnu.org>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
In-Reply-To: <47A00D43.60602@acm.org>
Message-ID: <Pine.LNX.4.64.0801300838550.12371@anakin>
References: <1201641765.18773.35.camel@dv> <1201652420.2271.91.camel@perihelion>
 <1201657701.24898.14.camel@dv> <20080130050424.GA22444@dallas.jonmasters.org>
 <47A00D43.60602@acm.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Zan Lynx wrote:
> Jon Masters wrote:
> > I wouldn't quite say that. I wasn't going to comment, but...personally,
> > I actually disagree with the assertions that ndiswrapper isn't causing
> > proprietary code to link against GPL functions in the kernel (how is
> > an NDIS implementation any different than a shim layer provided to
> > load a graphics driver?), but I wasn't trying to make that point.
> 
> Well, as long as *any* part of the kernel ever links to proprietary code, then
> GPL functions link to it in exactly the same way ndiswrapper enables.  It's
> only a matter of how many steps of separation.
> 
> A perfectly GPL USB network driver linked to GPL-only functions feeds data
> into the kernel where it swirls about and emerges from a proprietary network
> filesystem driver, for example.

A proprietary network filesystem driver _on a different system_, you
mean? In this case the proprietary code has no direct access to your
kernel data, except through the communication protocol. No tainting is
involved, as all corruption in your kernel is caused by kernel bugs in
visible code that can be debugged.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
