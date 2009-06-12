Return-Path: <linux-kernel-owner+w=401wt.eu-S1764136AbZFLJ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764136AbZFLJ4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763671AbZFLJ4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:56:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46413 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363AbZFLJ4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:56:04 -0400
Date: Fri, 12 Jun 2009 11:55:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: origin tree build failure
Message-ID: <20090612095546.GA23020@elte.hu>
References: <20090612102427.32582baa.sfr@canb.auug.org.au> <1244768406.7172.1.camel@pasglop> <20090612092054.GB32052@elte.hu> <1244799197.7172.106.camel@pasglop> <1244799786.6691.1133.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244799786.6691.1133.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2009-06-12 at 19:33 +1000, Benjamin Herrenschmidt wrote:
> > We should at least -try- to follow the
> > process we've defined, don't you think ?
>
> So you're saying -next should include whole new subsystems even 
> though its not clear they will be merged?
> 
> That'll invariably create the opposite case where a tree doesn't 
> get pulled and breaks bits due to its absence.
> 
> -next does a great job of sorting the existing subsystem trees, 
> but I don't think its Stephens job to decide if things will get 
> merged.
> 
> Therefore when things are in limbo (there was no definite ACK from 
> Linus on perf counters) both inclusion and exclusion from -next 
> can lead to trouble.

Precisely. linux-next is for the uncontroversial stuff from existing 
subsystems. Sometimes for features pushed by or approved by existing 
subsystem maintainers. But it is not for controversial stuff - Linus 
is the upstream maintainer, not Stephen.

We had a real mess with perfmon3 which was included into linux-next 
in a rouge way without Cc:-ing the affected maintainers and against 
the maintainers. There was a repeat incident recently as well, where 
a tree was included into linux-next without the approval (and 
without the Cc:) of affected maintainers. linux-next needs to be 
more careful about adding trees.

All in one, we did the same with perfcounters that we expected of 
perfmonv3. No double standard.

Nor is there any real issue here. The bug was my fault, it was 
trivial to fix, it affects a small subset of testers and it is 
already upstream, applied on the same day perfcounters were pulled.

	Ingo
