Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031Ab0AAPzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab0AAPzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 10:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916Ab0AAPzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 10:55:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46698 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0AAPzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 10:55:31 -0500
Date: Fri, 1 Jan 2010 16:55:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Wagner <daw-news@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20100101155530.GA25892@atrey.karlin.mff.cuni.cz>
References: <20091228163108.GC13266@heat> <14145.1262035489@localhost> <hhback$sor$1@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hhback$sor$1@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please use group reply, so that cc lists are preserved).

> Pavel writes:
> > Policy may well be "If the network works, noone can
> > log in locally, because administration is normally done over
> > network. If the network fails, larger set of people is allowed in,
> > because something clearly went wrong and we want anyone going around
> > to fix it."
> 
> Michael Stone writes:
> > Have you actually seen this security policy in real life?
> 
> Pavel responds:
> > Actually, I've seen a *lot* of similar [..] policies.
> 
> OK, so to translate: it sounds like the answer is No, you
> haven't seen this policy in real life.
> 
> More to the point, the real question is whether this policy
> is embedded in code anywhere such that Michael's mechanism would
> introduce a new security hole, and if so, whether the cost of
> that would outweigh the benefit of his mechanism.  I think the

Actually, no, this is not the (only) question. Kernel tries to be
backwards-compatible.

> answer is, No, no one even has a plausible story for how this
> policy might appear in some legacy executable that would then
> be newly subvertible due to Michael Stone's policy.  First off,

It is Michael's responsibility to prove that no legacy executable is
affected, and they clearly are.

(Another example would be DoS; imagine sendmail forking into
background from setuid program. It maybe even does that. Run that with
network disabled and you have DoSed mail system on the server.)

> I think what Michael is trying to do has the potential to be very
> valuable and should be supported, and this is not a convincing
> argument against it.

People already proposed systems (disablenetwork needs disablesuid)
that have all the advantages, and no security-related
back-compatibility problems


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
