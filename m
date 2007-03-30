Return-Path: <linux-kernel-owner+w=401wt.eu-S964769AbXC3KMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964769AbXC3KMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 06:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964813AbXC3KMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 06:12:12 -0400
Received: from colin.muc.de ([193.149.48.1]:3755 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964769AbXC3KML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 06:12:11 -0400
Date: 30 Mar 2007 12:12:09 +0200
Date: Fri, 30 Mar 2007 12:12:09 +0200
From: Andi Kleen <ak@muc.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Gerd Hoffmann <kraxel@suse.de>, Alan <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use X86_EFLAGS_IF in x86-64/irqflags.h.
Message-ID: <20070330101209.GA79904@muc.de>
References: <1175154408.12230.195.camel@localhost.localdomain> <20070329103602.GB52274@muc.de> <1175166417.12230.206.camel@localhost.localdomain> <20070329121958.GA35584@muc.de> <1175224343.12230.368.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175224343.12230.368.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 01:12:23PM +1000, Rusty Russell wrote:
> On Thu, 2007-03-29 at 14:19 +0200, Andi Kleen wrote:
> > On Thu, Mar 29, 2007 at 09:06:57PM +1000, Rusty Russell wrote:
> 
> [SNIP: processor-flags.h patch for i386 ]
> 
> > Ok. Can you do it for x86-64 too?
> 
> OK, here it is.  Compiles, but -rc5-mm2 doesn't link for me on x86-64 at
> the moment.

What's the problem? 

> 
> Something seems quite wrong with CONFIG_X86_VSMP.  AFAICT (1 << 18) is
> the "alignment check" flag, not the "virtual interrupt" flag which I
> expected.

They abuse that intentionally as a way to talk to their hypervisor.
You don't want to know details.

-Andi
