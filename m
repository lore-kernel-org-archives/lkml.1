Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbXEIJBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbXEIJBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbXEIJAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:00:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51706 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbXEIJAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:00:51 -0400
Date: Wed, 9 May 2007 11:00:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Frederik Deweerdt <deweerdt@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: kmem_cache_init failure (was Re: 2.6.21-mm1)
Message-ID: <20070509090046.GE17482@one.firstfloor.org>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <20070508172233.GA11683@slug> <46419708.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46419708.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 09:40:24AM +0200, Jan Beulich wrote:
> >I've bisected it down to the x86_64-mm-cpa-kerneltext.patch and the 
> >
> >+       if (!pte_present(*kpte))
> >+               return 0;
> 
> I the most recent version of the patch I sent to Andi this line is gone (again),
> as I realized it was wrong on i386 (namely for DEBUG_PAGEALLOC) and its
> respective variant was superfluous on x86-64.

Yes the version of the patch that went into Linus' tree doesn't have it.
Does the problem happen with mainline gitLATEST too?

-Andi
