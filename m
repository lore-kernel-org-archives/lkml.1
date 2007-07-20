Return-Path: <linux-kernel-owner+w=401wt.eu-S939397AbXGTBn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939397AbXGTBn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbXGTBnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:43:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760057AbXGTBnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:43:49 -0400
Date: Thu, 19 Jul 2007 18:43:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] mm: Remove slab destructors from
 kmem_cache_create().
In-Reply-To: <20070720012846.GA22487@linux-sh.org>
Message-ID: <alpine.LFD.0.999.0707191841330.27249@woody.linux-foundation.org>
References: <20070720012846.GA22487@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Jul 2007, Paul Mundt wrote:
> 
> Perhaps this is something that should go in later, as it does
> cause a bit of churn across the tree. However, there shouldn't be
> anything here that causes trouble for git merges, as it's all pretty
> straightforward removal. I've placed it in a git tree to pull as it's
> quite large, and not terribly interesting.

Ok, I thought twice about this, but 

 (a) I think most of the merging for 2.6.23 has been done

 (b) there's really no point in holding on to that thing

 (c) the patch looked beatiful in colorized version in gitk

so I decided I might as well just merge it. Looks fine to me, and there 
really is no point holding on to an interface that we've never really 
used, and that we don't even support any more.

		Linus
