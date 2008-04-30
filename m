Return-Path: <linux-kernel-owner+w=401wt.eu-S933250AbYD3T5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbYD3T5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbYD3T5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:57:37 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52606 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758740AbYD3T5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:57:37 -0400
Date: Wed, 30 Apr 2008 21:58:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] inlining: do not allow gcc below version 4 to optimize inlining
Message-ID: <20080430195810.GA4660@uranus.ravnborg.org>
References: <20080429221530.GA11398@elte.hu> <20080430190307.GC29330@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430190307.GC29330@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 10:03:07PM +0300, Adrian Bunk wrote:
> >  /*
> > - * Force always-inline if the user requests it so via the .config:
> > + * Force always-inline if the user requests it so via the .config,
> > + * or if gcc is too old:
> >   */
> >  #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
> > -    !defined(CONFIG_OPTIMIZE_INLINING) && (__GNUC__ >= 4)
> 
> One moment.
> 
> Let me try to understand what we currently have in the tree.
> 
> This *always* enables the so called "optimized inlining" for the older 
> compilers we did *not* wanted to have this for.
> 
> Even with CONFIG_OPTIMIZE_INLINING=n .
> 
> How was this reviewed and tested?

I for one reviewed this.
No I did not catch the obvious bug and
feel free to flame me for that.

	Sam
