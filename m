Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbYGWSkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbYGWSkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbYGWSjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:39:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195AbYGWSju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:39:50 -0400
Date: Wed, 23 Jul 2008 14:33:00 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: Adrian Bunk <bunk@kernel.org>
cc: Thomas Meyer <thomas@m3y3r.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: next-20080723: build fails for dm-snapshot.ko
In-Reply-To: <20080723182839.GF14846@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0807231431250.3332@devserv.devel.redhat.com>
References: <1216835917.19707.3.camel@dhcppc2> <20080723182839.GF14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008, Adrian Bunk wrote:

> On Wed, Jul 23, 2008 at 07:58:37PM +0200, Thomas Meyer wrote:
> > 
> >   Building modules, stage 2.
> > Kernel: arch/x86/boot/bzImage is ready  (#24)
> >   MODPOST 1518 modules
> > ERROR: "__umoddi3" [drivers/md/dm-snapshot.ko] undefined!
> > WARNING: modpost: Found 6 section mismatch(es).
> > To see full details build your kernel with:
> > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> >...
> 
> Which gcc version are you using?
> 
> Please send the complete .config
> 
> cu
> Adrian

I'm going to compile it on 32-bit computer to try.

But I'd just suggest: why don't we add these functions __umoddi3 __udivdi3 
and so to the kernel? This is not the first time I see it and it is pretty 
annoying (and compiler- and optimization-dependent bug).

Mikulas
