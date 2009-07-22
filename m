Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZGVQcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZGVQcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZGVQcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:32:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753191AbZGVQcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:32:13 -0400
Date: Wed, 22 Jul 2009 09:31:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>
Subject: Re: [RFC/PATCH] mm: Pass virtual address to
 [__]p{te,ud,md}_free_tlb()
In-Reply-To: <1248073873.13067.31.camel@pasglop>
Message-ID: <alpine.LFD.2.01.0907220930320.19335@localhost.localdomain>
References: <20090715074952.A36C7DDDB2@ozlabs.org>  <20090715135620.GD7298@wotan.suse.de> <1248073873.13067.31.camel@pasglop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Jul 2009, Benjamin Herrenschmidt wrote:

> On Wed, 2009-07-15 at 15:56 +0200, Nick Piggin wrote:
> > > I would like to merge the new support that depends on this in 2.6.32,
> > > so unless there's major objections, I'd like this to go in early during
> > > the merge window. We can sort out separately how to carry the patch
> > > around in -next until then since the powerpc tree will have a dependency
> > > on it.
> > 
> > Can't see any problem with that.
> 
> CC'ing Linus here. How do you want to proceed with that merge ? (IE. so
> far nobody objected to the patch itself)

Maybe you can put it as a separate branch in -next, and have it merged 
before the stuff that depends on it, and then just sending it to me (as a 
git branch or patch or whatever) in the first day of the merge window?

		Linus
