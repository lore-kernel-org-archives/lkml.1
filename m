Return-Path: <linux-kernel-owner+w=401wt.eu-S2993105AbXEBMzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993105AbXEBMzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993116AbXEBMzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:55:09 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:4188 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993105AbXEBMzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:55:07 -0400
Date: Wed, 2 May 2007 13:54:53 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <20070501133618.93793687.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705021346170.16517@blonde.wat.veritas.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <20070501133618.93793687.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 02 May 2007 12:55:06.0455 (UTC) FILETIME=[1BAD9E70:01C78CB9]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBjbGFtZXRlckBzZ2kuY29tAGxpbnV4LW1tQGt2YWNrLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Andrew Morton wrote:
> 
> Given the current state and the current rate of development I'd expect slub
> to have reached the level of completion which you're describing around -rc2
> or -rc3.  I think we'd be pretty safe making that assumption.

Its developer does show signs of being active!

> 
> This is a bit unusual but there is of course some self-interest here: the
> patch dependencies are getting awful and having this hanging around
> out-of-tree will make 2.6.23 development harder for everyone.

That is a very strong argument: a somewhat worrisome argument,
but a very strong one.  Maintaining your sanity is important.

> 
> So on balance, given that we _do_ expect slub to have a future, I'm
> inclined to crash ahead with it.  The worst that can happen will be a later
> rm mm/slub.c which would be pretty simple to do.

Okay.  And there's been no chorus to echo my concern.

But if Linus' tree is to be better than a warehouse to avoid
awkward merges, I still think we want it to default to on for
all the architectures, and for most if not all -rcs.

> 
> otoh I could do some frantic patch mangling and make it easier to carry
> slub out-of-tree, but do we gain much from that?

No, keep away from that.

Hugh
