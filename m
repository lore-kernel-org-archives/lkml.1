Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbZL1WKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbZL1WKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZL1WKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:10:30 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:48453 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZL1WK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:10:29 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: RFC: disablenetwork facility. (v4)
Date: Mon, 28 Dec 2009 22:10:28 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hhback$sor$1@taverner.cs.berkeley.edu>
References: <20091228163108.GC13266@heat> <14145.1262035489@localhost>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1262038228 29467 128.32.153.193 (28 Dec 2009 22:10:28 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 28 Dec 2009 22:10:28 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel writes:
> Policy may well be "If the network works, noone can
> log in locally, because administration is normally done over
> network. If the network fails, larger set of people is allowed in,
> because something clearly went wrong and we want anyone going around
> to fix it."

Michael Stone writes:
> Have you actually seen this security policy in real life?

Pavel responds:
> Actually, I've seen a *lot* of similar [..] policies.

OK, so to translate: it sounds like the answer is No, you
haven't seen this policy in real life.

More to the point, the real question is whether this policy
is embedded in code anywhere such that Michael's mechanism would
introduce a new security hole, and if so, whether the cost of
that would outweigh the benefit of his mechanism.  I think the
answer is, No, no one even has a plausible story for how this
policy might appear in some legacy executable that would then
be newly subvertible due to Michael Stone's policy.  First off,
this sounds like a pretty wacko policy.  Second, it's unlikely
to be embedded in a setuid-root executable that anyone can
execute.  Third, if there were such a setuid-root executable
(which I've already argued is in fantasy land, but let's suppose
pigs could fly and such a thing existed in practice), there are
other ways to attack it: such as by using up all available
file descriptors and then forking and execing that executable.
Fourth, even if it existed, it would be a very rare one-off
site-specific thing.  But most importantly, we're way off the
rails onto speculation.  Of course you can always imagine some
conceivable scenario under which any new mechanism might have
unwanted side effects -- that's just the nature of any complex
system -- but I don't see any reasonable argument at all that
Michael's mechanism will cause more harm than good.

Bottom lien: I agree with Michael Stone.  I think this
objection is weak.

I think what Michael is trying to do has the potential to be very
valuable and should be supported, and this is not a convincing
argument against it.
