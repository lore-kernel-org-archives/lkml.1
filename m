Return-Path: <linux-kernel-owner+w=401wt.eu-S936030AbYBGV0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936030AbYBGV0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934971AbYBGV0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:26:17 -0500
Received: from gate.crashing.org ([63.228.1.57]:56303 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933693AbYBGV0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:26:15 -0500
Subject: Re: Xilinx: hwicap driver comments
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, stephen.neuendorffer@xilinx.com,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Kumar Gala <galak@gate.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <fa686aa40802071254p172103f0w423f4591583ca3ef@mail.gmail.com>
References: <47AB6552.7040503@gmail.com>
	 <20080207124203.147ce300.akpm@linux-foundation.org>
	 <fa686aa40802071254p172103f0w423f4591583ca3ef@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 08:25:45 +1100
Message-Id: <1202419545.7079.136.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-07 at 13:54 -0700, Grant Likely wrote:
> On 2/7/08, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Thu, 07 Feb 2008 21:08:50 +0100
> > How it got from there into Linux is also a mystery.  I see a batch of
> > powerpc updates just went into mainline but I don't know whose tree was
> > pulled - I wasn't copied on any pull request and I can't find one on the
> > kernel mailing list.
> >
> > Perhaps Paul has just done a stealth merge, but the patch to which you
> > refer doesn't have his signoff.  Very confused.
> 
> It went through my tree.  Paul pulls from Josh Boyer's tree for
> powerpc-4xx patches, and Josh pulls from mine for xilinx virtex
> powerpc 405 patches.
> 
> My screw up, sorry I broke the rules.  What is the best way to resolve this?

It's unclear to me whether you did anything wrong here.

This driver is totally platform specific (it's not like it was a
wireless driver or something like that) and has been reviewed on the
platform mailing list (even if, apprently, not enough).

If those problems haven't been spotted, then too bad, and thanks Jiri
for picking them up later on, that's much welcome, but I don't think we
should start having all of the platform bits go through lkml, it
wouldn't be practical at all.

As far as -mm is concerned, that depends how long this has been in
paulus tree before the merge window I suppose. I suspect that while
paulus for-2.6.25 has been around getting ready for merge for some time
now (we've been good citizen in that regard, getting everything together
way before the actual merge window), we haven't necessarily yet totally
sorted out the timing with out own sub-maintainer and sub-sub-maintainer
trees (powerpc is a complicated architecture !).

So while I would have expected this to show up at least for a little
while in -mm via paulus for-2.6.25, it's possible that it didn't happen,
or that paulus didn't include for-2.6.25 in powerpc.git or something
like that....

So we can try to improve in this area, but I don't think Grant himself
did anything wrong including that driver in his tree and having paul
merge it, except maybe for a bit more in depth review (but we all do
miss things sometimes).

Cheers,
Ben.


