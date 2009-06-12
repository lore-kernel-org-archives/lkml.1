Return-Path: <linux-kernel-owner+w=401wt.eu-S1761801AbZFLJ6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761801AbZFLJ6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933553AbZFLJ6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:58:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:55686 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761718AbZFLJ6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:58:04 -0400
Subject: Re: linux-next: origin tree build failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <1244799786.6691.1133.camel@laptop>
References: <20090612102427.32582baa.sfr@canb.auug.org.au>
	 <1244768406.7172.1.camel@pasglop>  <20090612092054.GB32052@elte.hu>
	 <1244799197.7172.106.camel@pasglop>  <1244799786.6691.1133.camel@laptop>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 19:57:15 +1000
Message-Id: <1244800635.7172.114.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 11:43 +0200, Peter Zijlstra wrote:
> On Fri, 2009-06-12 at 19:33 +1000, Benjamin Herrenschmidt wrote:
> > We should at least -try- to follow the
> > process we've defined, don't you think ?
> 
> So you're saying -next should include whole new subsystems even though
> its not clear they will be merged?

Maybe yes. And if there's some debate as to whether it should be merged
or not, maybe Linus should make the decision, let -next carry it for a
few days to iron out those problems, and -then- merge it.

> That'll invariably create the opposite case where a tree doesn't get
> pulled and breaks bits due to its absence.
> 
> -next does a great job of sorting the existing subsystem trees, but I
> don't think its Stephens job to decide if things will get merged.

No, it's not, but then, maybe Linus could play the game and -tell- us
whether he intend to merge or not at least a few days in advance :-)

> Therefore when things are in limbo (there was no definite ACK from Linus
> on perf counters) both inclusion and exclusion from -next can lead to
> trouble.

Well, Linus did ACK by merging :-) So he should have been able to give
that ack a few days in advance too..

Cheers,
Ben.


