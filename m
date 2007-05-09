Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbXEISGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbXEISGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXEISGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:06:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:49902 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbXEISGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:06:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=ZBtIrb5HzxC78uryvKnTWhnzPbrQrJrWGztS87VT+0nZ2CqKzBrEWtERGE1H3OuBiwPuXMx4Cga4xYHNVFeQVlSbWx3yPWBppFD7mhW/qAjpMNX7yo2DIC16CucWc/eV2nRUu8w4iCvYrEha0/QYPtG6bJxBJjkWWr+kukffQLw=
Date: Wed, 9 May 2007 20:04:52 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: kmem_cache_init failure (was Re: 2.6.21-mm1)
Message-ID: <20070509180451.GA17402@slug>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <20070508172233.GA11683@slug> <46419708.76E4.0078.0@novell.com> <20070509090046.GE17482@one.firstfloor.org> <20070509122608.GC11683@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509122608.GC11683@slug>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 02:26:08PM +0200, Frederik Deweerdt wrote:
> On Wed, May 09, 2007 at 11:00:46AM +0200, Andi Kleen wrote:
> > On Wed, May 09, 2007 at 09:40:24AM +0200, Jan Beulich wrote:
> > > >I've bisected it down to the x86_64-mm-cpa-kerneltext.patch and the 
> > > >
> > > >+       if (!pte_present(*kpte))
> > > >+               return 0;
> > > 
> > > I the most recent version of the patch I sent to Andi this line is gone (again),
> > > as I realized it was wrong on i386 (namely for DEBUG_PAGEALLOC) and its
> > > respective variant was superfluous on x86-64.
> > 
> > Yes the version of the patch that went into Linus' tree doesn't have it.
> > Does the problem happen with mainline gitLATEST too?
> Andi,
> 
> Latest git is OK with qemu, I'll test it on a real machine tonight.
It boots fine on a real PC too. Thanks!

Frederik
