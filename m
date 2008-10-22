Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYJVHB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYJVHB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYJVHBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:01:40 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:47513 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbYJVHBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:01:39 -0400
Date: Wed, 22 Oct 2008 09:01:37 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/20] m68k: use the new byteorder headers
In-Reply-To: <1224621302.5768.0.camel@brick>
Message-ID: <Pine.LNX.4.64.0810220900230.8356@anakin>
References: <1224525138.31861.206.camel@brick> <Pine.LNX.4.64.0810212003530.8356@anakin>
 <1224621302.5768.0.camel@brick>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008, Harvey Harrison wrote:
> On Tue, 2008-10-21 at 20:05 +0200, Geert Uytterhoeven wrote:
> > On Mon, 20 Oct 2008, Harvey Harrison wrote:
> > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > > ---
> > > The final prerequisite patches to prevent breakage of headers-install and
> > > usage of the swabb.h functions have gone into mainline, please move your arch
> > > to the new header.
> > > 
> > > b8e465f4945bc0e9f324e3bbe15f5180a8e9a6fe byteorder: add new headers for make headers-install
> > > acf0108a84edae22b99655eb2f6f6c9f7ec4d449 byteorder: use generic C version for value byteswapping
> > > 1d8cca44b6a244b7e378546d719041819049a0f9 byteorder: provide swabb.h generically in asm/byteorder.h
> > > 1a651a00e20fd4997f0b91258f6f95b7d96edcd9 byteorder: remove direct includes of linux/byteorder/swab[b].h
> > > 
> 
> A hunk got lost, see mainline:
> 
> > commit f07767fd0f95c385108fa4c456a9cb216a424fec
> > Author: Harvey Harrison <harvey.harrison@gmail.com>
> > Date:   Mon Oct 20 10:23:38 2008 -0700
> > 
> >     byteorder: remove direct includes of linux/byteorder/swab[b].h
> >     
> >     A consolidated implementation will provide this generically through
> >     asm/byteorder, remove direct includes to avoid breakage when the
> >     changeover to the new implementation occurs.
> >     
> >     This hunk was lost from commit 1d8cca44b6a244b7e378546d719041819049a0f9
> >     ("byteorder: provide swabb.h generically in asm/byteorder.h")
> >     
> >     Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Ah, my tree didn't have that one yet.
After upgrading, kernel/rcutorture.c compiles again.
I'll let you know if more breakage pops up (I expect not, as I built
with `make -k' ;-).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
