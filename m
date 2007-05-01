Return-Path: <linux-kernel-owner+w=401wt.eu-S1030181AbXEAUTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181AbXEAUTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964974AbXEAUTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:19:25 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:14571 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964780AbXEAUTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:19:24 -0400
Date: Tue, 1 May 2007 21:19:09 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <20070501125559.9ab42896.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 01 May 2007 20:19:23.0466 (UTC) FILETIME=[0214F2A0:01C78C2E]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBjbGFtZXRlckBzZ2kuY29tAGxpbnV4LW1tQGt2YWNrLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Andrew Morton wrote:
> On Tue, 1 May 2007 19:10:29 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > > Most of the rest of slub.  Will merge it all.
> > 
> > Merging slub already?  I'm surprised.
> 
> My thinking here is "does slub have a future".
> I think the answer is "yes",

I think I agree with that,
though it's a judgement I'd leave to you and others.

> so we're reasonably safe getting it into mainline for the finishing
> work.  The kernel.org kernel will still default to slab.
> 
> Does that sound wrong?

Yes, to me it does.  If it could be defaulted to on throughout the
-rcs, on every architecture, then I'd say that's "finishing work";
and we'd be safe knowing we could go back to slab in a hurry if
needed.  But it hasn't reached that stage yet, I think.

Hugh
