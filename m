Return-Path: <linux-kernel-owner+w=401wt.eu-S933940AbXC1Whv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940AbXC1Whv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934045AbXC1Whv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:37:51 -0400
Received: from holomorphy.com ([66.93.40.71]:47504 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933940AbXC1Whu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:37:50 -0400
Date: Wed, 28 Mar 2007 15:37:53 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
Message-ID: <20070328223753.GZ8915@holomorphy.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com> <20070328134511.0d61ec8f.akpm@linux-foundation.org> <Pine.LNX.4.64.0703281401460.13743@schroedinger.engr.sgi.com> <20070328211658.GE2986@holomorphy.com> <Pine.LNX.4.64.0703281418040.13870@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703281418040.13870@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, William Lee Irwin III wrote:
>> I already went over the methodological issues with kernel compiles.
>> You may be able to prove this, but not this way.

On Wed, Mar 28, 2007 at 02:20:20PM -0700, Christoph Lameter wrote:
> But this way is an established kernel way of doing things. Seems that my 
> AIM9 stuff was not convincing and I am not sure what other tests would be 
> acceptable. Could you post some of data regarding the improvements 
> possible through your patches?

What I did, I did a number of years ago. Even if I could find the
results (and I don't even recall order-of-magnitude estimates) they
would be effectively irrelevant to modern kernels. The disaster in
all this was that the PTE caching never got merged. It's not much of
an observation to note that the primarily bottleneck is still there
when the patch to resolve it never got merged.

As far as kernel compiles being relevant to anything besides
potentially optimizing a particular major benchmark using gcc as one
of its components... yeah, right. It's too macro to be a microbenchmark
of anything and too micro to be pertinent to any meaningful
macrobenchmark such as those from major benchmark publishers (who can't
be named for trademark/etc. reasons). Hasn't it been at least 5 years
since people figured out kernel compiles were complete bulls**t as
benchmarks along with dbench for other reasons and several others? If
not, I don't know why I bother with this kernel at all.

Even so, I already did this and am done with it. It's not like I'm
not carrying around numerous patches I know will never be merged all
the time anyway. If you want to back it all out so badly, just do it
and stop bothering me about it, and I'll merely continue maintaining my
local patches without ever posting them as I have been for years. I'm
not at all happy with the NIH situation, either, not that I'm at such a
loss for ideas to need to contest every petty NIH that flies past.


-- wli
