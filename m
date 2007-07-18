Return-Path: <linux-kernel-owner+w=401wt.eu-S932675AbXGRLpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675AbXGRLpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 07:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbXGRLpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 07:45:04 -0400
Received: from ozlabs.org ([203.10.76.45]:46921 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292AbXGRLpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 07:45:03 -0400
Subject: Re: [PATCH 1/3] Standardize x86_64's desc_defs.h in preparation
	for exposure to i386.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070718090302.GA67073@muc.de>
References: <1184743355.10380.112.camel@localhost.localdomain>
	 <20070718090302.GA67073@muc.de>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 21:44:45 +1000
Message-Id: <1184759085.10380.137.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 11:03 +0200, Andi Kleen wrote:
> On Wed, Jul 18, 2007 at 05:22:34PM +1000, Rusty Russell wrote:
> > However, the currently (i386-derived) x86-64 ones are suboptimal.  The
> 
> In what way are they suboptimal? 

This was badly worded.  They're "suboptimal" for use by i386 (ie. they
clash with the i386 declaration and they'd need lots of casts to convert
the code).

Of course, treating them as 2 32-bit values on x86-64 *is* suboptimal,
and this patch helps that, but that wasn't what I was talking about.

> They seem to work just fine.

Yep.   But my first attempt was to simply #include
<asm-x86_64/desc_defs.h> from asm-i386, and that doesn't work fine 8(

Thanks,
Rusty.


