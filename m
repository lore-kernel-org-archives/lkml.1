Return-Path: <linux-kernel-owner+w=401wt.eu-S1030574AbXCNGnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030574AbXCNGnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 02:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030668AbXCNGnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 02:43:51 -0400
Received: from ozlabs.org ([203.10.76.45]:42710 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030574AbXCNGnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 02:43:50 -0400
Subject: Re: [PATCH] Introduce load_TLS to the "for" loop.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070313205526.GA46469@muc.de>
References: <1173767976.10618.50.camel@localhost.localdomain>
	 <20070313135000.GA92373@muc.de> <45F6DFEF.2090008@goop.org>
	 <20070313205526.GA46469@muc.de>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 17:43:34 +1100
Message-Id: <1173854614.19022.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 21:55 +0100, Andi Kleen wrote:
> On Tue, Mar 13, 2007 at 10:31:27AM -0700, Jeremy Fitzhardinge wrote:
> > Andi Kleen wrote:
> > > On Tue, Mar 13, 2007 at 05:39:36PM +1100, Rusty Russell wrote:
> > >   
> > >> GCC (4.1 at least) unrolls it anyway, but I can't believe this code
> > >>     
> > >
> > > Are you sure? Normally it doesn't unroll without -funroll-loops which
> > > the kernel does normally not set. Especially not with -Os builds.
> > >   
> > 
> > Does it matter either way in this case?
> 
> It's in the middle of the context switch.

Well, the rest of __switch_to isn't "0PTIM1Z3D!!!" like this.

But even so, that's no excuse for crap code.  If it had used memcpy, we
wouldn't be wasting cycles on this discussion.

Rusty.


