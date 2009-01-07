Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZAGF1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZAGF1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 00:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZAGF04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 00:26:56 -0500
Received: from relais.videotron.ca ([24.201.245.36]:49641 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZAGF04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 00:26:56 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 07 Jan 2009 00:26:50 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: powerpc: introduce asm/swab.h
In-reply-to: <alpine.LFD.2.00.0901070017550.26118@xanadu.home>
Message-id: <alpine.LFD.2.00.0901070024410.26118@xanadu.home>
References: <200901070400.n0740Ore002063@hera.kernel.org>
 <1231303340.14860.61.camel@pasglop> <1231304552.14860.72.camel@pasglop>
 <alpine.LFD.2.00.0901062108440.3057@localhost.localdomain>
 <alpine.LFD.2.00.0901070017550.26118@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009, Nicolas Pitre wrote:

> On Tue, 6 Jan 2009, Linus Torvalds wrote:
> 
> > 
> > 
> > On Wed, 7 Jan 2009, Benjamin Herrenschmidt wrote:
> > > 
> > > Even if fixing that to use __swab32() instead, then it fails because
> > > this is defined after it's used. I worked around it using fswab in
> > > there instead.
> > 
> > That's the same patch I just sent out (but you changed comments too), so I 
> > obviously agree. 
> > 
> > x86 didn't see this (even in 32-bit mode) because it doesn't use that odd 
> > __SWAB_64_THRU_32__ case, but does the 64-bit swab with native code.
> > 
> > Can you also verify that it works for you (not just compiles), just so 
> > that I can commit it?
> 
> Tested OK on ARM (using LE mode with networking, etc.)

Well, given that I have no way to test any code path including 
be64_to_cpu() and its opposite, my testing is only valid for 
compilation issues.


Nicolas
