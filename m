Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYHDDhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYHDDhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 23:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYHDDg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 23:36:58 -0400
Received: from ozlabs.org ([203.10.76.45]:51758 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbYHDDg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 23:36:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Introduce down_try() so we can move away from down_trylock()
Date: Mon, 4 Aug 2008 13:28:45 +1000
User-Agent: KMail/1.9.9
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, "Randy.Dunlap" <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
References: <200807291015.02865.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808031031380.3668@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808031034400.3668@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808031034400.3668@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808041328.45773.rusty@rustcorp.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2008 03:35:41 Linus Torvalds wrote:
> On Sun, 3 Aug 2008, Linus Torvalds wrote:
> > Anyway, I NAK'ed your patches. Deal with it.
>
> Btw, "dealing with it" can just be "don't bother".

Yes, let's not make a mountain out of a molehill.

Someone sent me a patch documenting the illogic of down_trylock().  I decided 
to try to fix it rather than just bitch and moan.

Kernel coding involves occasionally getting fed a Linus-special shit sandwich 
rant.  I've long given up expecting a polite "No; please just replace them 
all with mutexes" one-liner.  I might have actually been shocked into doing 
it.

Consider the patches forgotten,
Rusty.
