Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbXDFGFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbXDFGFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 02:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbXDFGFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 02:05:34 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:32129 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbXDFGFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 02:05:33 -0400
X-AuditID: d80ac287-92925bb000000c42-4b-4615e32c9334 
Date: Fri, 6 Apr 2007 07:05:22 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Eric Dumazet <dada1@cosmosbay.com>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FUTEX : new PRIVATE futexes
In-Reply-To: <4615A009.808@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0704060644150.4723@blonde.wat.veritas.com>
References: <20060808070708.GA3931@localhost.localdomain>
 <200608090826.28249.dada1@cosmosbay.com> <200608090843.52893.dada1@cosmosbay.com>
 <200703152010.35614.dada1@cosmosbay.com> <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
 <20070405194942.1414c030.dada1@cosmosbay.com> <4615A009.808@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 06 Apr 2007 06:05:31.0778 (UTC) FILETIME=[9549FE20:01C77811]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007, Nick Piggin wrote:
> 
> I like |= for adding flags, it seems less ambiguous. But I guess that's
> a matter of opinion. Hugh seems to like +=,

Do I?  You probably have a shaming example in mind (PAGE_MAPPING_ANON?
that's a hybrid case where using + and - helped minimize the casting);
but in general I'd agree with you that it's |= for setting flag bits.

Hmm, Eric's FUT_OFF_INODE is hybrid too, that might justify the +=

> and I can't argue with him about style issues ;)

I feel a warm glow.  Nobody ever called me a style guru before.

Hugh

p.s.  Please don't interpret this as any useful contribution to
reviewing Eric's futex work: seems sensible, but I've hardly looked.
