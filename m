Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbYC1SlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbYC1SlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYC1SlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:41:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52123 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750906AbYC1SlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:41:00 -0400
Date: Fri, 28 Mar 2008 11:38:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <alpine.LFD.1.00.0803281116460.14670@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803281138130.17805@schroedinger.engr.sgi.com>
References: <200803272353.51901.rjw@sisk.pl> 
 <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com> 
 <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org> 
 <84144f020803281015s60370d9dpec0913c33004b6c2@mail.gmail.com> 
 <alpine.LFD.1.00.0803281017500.14670@woody.linux-foundation.org>
 <84144f020803281108o178bf62cp48dcd4f43ec59b74@mail.gmail.com>
 <alpine.LFD.1.00.0803281116460.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008, Linus Torvalds wrote:

> The code in question is __slab_alloc(). It did *not* clear it correctly 
> before its uses (__slab_alloc -> kmalloc_large -> __get_free_pages).

But why could have __GFP_ZERO there be harmful? Its a non highmem 
allocation. No kmap needed.

