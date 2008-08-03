Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbYHCRhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbYHCRhY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbYHCRhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:37:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756446AbYHCRhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:37:11 -0400
Date: Sun, 3 Aug 2008 10:35:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, "Randy.Dunlap" <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Introduce down_try() so we can move away from
 down_trylock()
In-Reply-To: <alpine.LFD.1.10.0808031031380.3668@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808031034400.3668@nehalem.linux-foundation.org>
References: <200807291015.02865.rusty@rustcorp.com.au> <200807292301.18733.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808011022230.3277@nehalem.linux-foundation.org> <200808031833.32048.rusty@rustcorp.com.au>
 <alpine.LFD.1.10.0808031031380.3668@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 3 Aug 2008, Linus Torvalds wrote:
> 
> Anyway, I NAK'ed your patches. Deal with it.

Btw, "dealing with it" can just be "don't bother".

Leaving old stuff _alone_ is a perfectly good approach. Being slightly 
ugly for historical reasons is much less of a problem than just "change 
for change's sake".

			Linus
