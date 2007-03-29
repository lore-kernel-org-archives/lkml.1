Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbXC2BJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbXC2BJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 21:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934288AbXC2BJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 21:09:28 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41567 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932280AbXC2BJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 21:09:28 -0400
Date: Wed, 28 Mar 2007 18:09:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
In-Reply-To: <20070329005356.GA8915@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0703281800460.25452@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
 <20070328134511.0d61ec8f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703281401460.13743@schroedinger.engr.sgi.com>
 <20070328211658.GE2986@holomorphy.com> <Pine.LNX.4.64.0703281418040.13870@schroedinger.engr.sgi.com>
 <20070328223753.GZ8915@holomorphy.com> <Pine.LNX.4.64.0703281636400.14657@schroedinger.engr.sgi.com>
 <20070329005356.GA8915@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, William Lee Irwin III wrote:

> NIH == "Not Invented Here." Basically a sort of idea theft, often used
> to grab credit for patches. You're not the one involved there. That was
> a digression. One could say, though, that a solution to the slab issues
> is to NIH slab allocators e.g. via quicklist.h/quicklist.c without the
> negative connotation.

Oh. The quicklist were actually taken from existing IA64 code. Not my idea 
either. I am not wedded to any solution and I was certainly not intending
to abscond with your idea. Would have been difficult given that there was 
a signoff line with your name on it.

> On Wed, Mar 28, 2007 at 04:44:01PM -0700, Christoph Lameter wrote:
> > We certainly see even from the rudimentary tests that I have done
> > that the limited pgd, pmd caching has some effect. Could we please
> > see your local patches? And I guess that you must have some sort of
> > benchmark that you run to test these?
> 
> Short answer: No.
> 
> Long answer: Most of the local patches are not likely to be of interest
> to the world at large. The ones I probably don't mind mentioning so
> much are things like ports of ipt_TARPIT.c to -CURRENT, support for
> mmap() of /proc/profile, things to make the notsc boot parameter
> actually do what you'd expect it to do instead of the kernel ignoring
> the option when you actually need it and mucking with the TSC behind
> your back, and so on. There are also things I'd rather keep under wraps
> so they don't mysteriously appear on lkml a few years later posted by
> someone else without any attribution to me (i.e. the NIH's that bother
> me). I've not got any of them ported to current mainline anyway, and
> some data loss from fried disks seems to have eaten most/all of the
> post-2.6.0 revisions of these patches anyway, though I've got compiled
> kernels with them on various kernel versions between then and 2.6.10
> (not to say that's any impediment to my hammering out fresh ports).

Ummm..... So nothing concrete on the performance issues that we 
are considering here? We are talking about something that was lost
a couple of years ago? There are certainly other people who will have the 
same ideas given enough time. Software and patches age like groceries. 
Hiding them will just make them wither away.
