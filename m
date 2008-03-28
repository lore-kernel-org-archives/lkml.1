Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbYC1UB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbYC1UB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbYC1UBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:01:18 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36094 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYC1UBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:01:18 -0400
Message-ID: <47ED4E33.9070203@cs.helsinki.fi>
Date: Fri, 28 Mar 2008 21:59:47 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
References: <200803272353.51901.rjw@sisk.pl>  <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>  <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>  <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>  <84144f020803281015s60370d9dpec0913c33004b6c2@mail.gmail.com>  <alpine.LFD.1.00.0803281017500.14670@woody.linux-foundation.org> <84144f020803281108o178bf62cp48dcd4f43ec59b74@mail.gmail.com> <alpine.LFD.1.00.0803281116460.14670@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803281116460.14670@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> That stupid clearing in new_slab() is totally and utterly irrelevant (in 
> addition to the fact that it's hard to spot).
> 
> The point was never new_slab(). So why do you even mention it?

Because I didn't spot that we're calling kmalloc_large() in the fallback 
path too. I was referring to the page allocator pass-through 
kmalloc_large() call that happens before we hit __slab_alloc. My bad, sorry.

			Pekka
