Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYKZMMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYKZMMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYKZMLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:11:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44140 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbYKZMLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:11:51 -0500
Date: Wed, 26 Nov 2008 13:22:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andi Kleen <andi@firstfloor.org>, eranian@googlemail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, eranian@gmail.com
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Message-ID: <20081126122217.GW6703@one.firstfloor.org>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com> <20081126113309.GS6703@one.firstfloor.org> <20081126230529.ab37fb32.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126230529.ab37fb32.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 11:05:29PM +1100, Stephen Rothwell wrote:
> Hi Andi,
> 
> On Wed, 26 Nov 2008 12:33:09 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> >
> > > + * x86 does not need extra alignment requirements for the sampling buffer
> > > + */
> > > +#define PFM_ARCH_SMPL_ALIGN_SIZE	0
> > > +
> > > +asmlinkage void  pmu_interrupt(void);
> > > +
> > > +static inline void pfm_arch_bv_copy(u64 *a, u64 *b, int nbits)
> > 
> > All these bitmap wrappers just seem like unnecessary obfuscation.
> > Could you just drop them and call the standard functions directly?
> 
> These were added after comments from the PowerPC maintainer since how the
> bitmaps are accessed needs to be arch specific.

Why? They should not be exported outside, so endian shouldn't matter, should
it?

-Andi
