Return-Path: <linux-kernel-owner+w=401wt.eu-S1763893AbYARReJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763893AbYARReJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764045AbYARRdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:33:55 -0500
Received: from waste.org ([66.93.16.53]:45869 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761912AbYARRdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:33:54 -0500
Subject: Re: 2.6.24-rc8-mm1: powerpc oopses
From: Matt Mackall <mpm@selenic.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       paulus@samba.org, linuxppc-dev@ozlabs.org
In-Reply-To: <200801181823.07718.m.kozlowski@tuxland.pl>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	 <20080117162913.0323c517.akpm@linux-foundation.org>
	 <1200617237.3839.32.camel@cinder.waste.org>
	 <200801181823.07718.m.kozlowski@tuxland.pl>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 11:33:12 -0600
Message-Id: <1200677592.3835.11.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-18 at 18:23 +0100, Mariusz Kozlowski wrote:
> Hello,
> 
> > > Do we need `offset' at all?
> > 
> > Looks like no.
> > 
> > I wonder if there's a good argument for adding a pte_offset_val() which
> > would let us do:
> > 
> > pteval = pte_offset_val(pmd, addr);
> > 
> > and shrink the map/unmap window and overhead here and possibly
> > elsewhere?
> > 
> > Anyway, updated but still untested patch now with revealing comment:
> 
> I patched the ppc32 kernel with this and run tests on /proc.
> This patch helps. No more BUGs and oopses :)

Thanks, Andrew's already queued it up.

-- 
Mathematics is the supreme nostalgia of our time.

