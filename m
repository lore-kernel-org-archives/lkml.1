Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbXEIM13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbXEIM13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbXEIM1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:27:21 -0400
Received: from hu-out-0506.google.com ([72.14.214.232]:1722 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbXEIM1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=t5sa5tWYwX2Im6iNpy6uE7x7oYwYGfS5Va3Gkb3wCLuzmQ7Hwey8Vv6OgpRIiCxwbKGtgbIQhVRTCSA6gbYGRCa1BerpGORVK/krHE+afwAsU+SRyvO6zAO+cJ3mP8tN5LsgkoZ4MHIRlSAU7EDN+hDCDbdLfjBKVZ7Pc+VKvgk=
Date: Wed, 9 May 2007 14:26:08 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: kmem_cache_init failure (was Re: 2.6.21-mm1)
Message-ID: <20070509122608.GC11683@slug>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <20070508172233.GA11683@slug> <46419708.76E4.0078.0@novell.com> <20070509090046.GE17482@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509090046.GE17482@one.firstfloor.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 11:00:46AM +0200, Andi Kleen wrote:
> On Wed, May 09, 2007 at 09:40:24AM +0200, Jan Beulich wrote:
> > >I've bisected it down to the x86_64-mm-cpa-kerneltext.patch and the 
> > >
> > >+       if (!pte_present(*kpte))
> > >+               return 0;
> > 
> > I the most recent version of the patch I sent to Andi this line is gone (again),
> > as I realized it was wrong on i386 (namely for DEBUG_PAGEALLOC) and its
> > respective variant was superfluous on x86-64.
> 
> Yes the version of the patch that went into Linus' tree doesn't have it.
> Does the problem happen with mainline gitLATEST too?
Andi,

Latest git is OK with qemu, I'll test it on a real machine tonight.

Frederik
