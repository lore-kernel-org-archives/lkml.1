Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbXJDMaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbXJDMaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 08:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbXJDMaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 08:30:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34153 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbXJDMaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 08:30:16 -0400
Subject: Re: [13/18] x86_64: Allow fallback for the stack
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, travis@sgi.com
In-Reply-To: <200710041425.43343.ak@suse.de>
References: <20071004035935.042951211@sgi.com>
	 <200710041356.51750.ak@suse.de> <1191499692.22357.4.camel@twins>
	 <200710041425.43343.ak@suse.de>
Content-Type: text/plain
Date: Thu, 04 Oct 2007 14:30:09 +0200
Message-Id: <1191501009.22357.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-04 at 14:25 +0200, Andi Kleen wrote:
> > The order-1 allocation failures where GFP_ATOMIC, because SLUB uses !0
> > order for everything.
> 
> slub is wrong then. Can it be fixed?

I think mainline slub doesn't do this, just -mm.

See DEFAULT_MAX_ORDER in mm/slub.c

> > Kernel stack allocation is GFP_KERNEL I presume. 
> 
> Of course.
> 
> > Also, I use 4k stacks on all my machines.
> 
> You don't have any x86-64 machines?

Ah, my bad, yes I do, but I (wrongly) thought they had that option too.

