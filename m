Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbYDOIrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbYDOIrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbYDOIrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:47:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34716 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbYDOIrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:47:17 -0400
Date: Tue, 15 Apr 2008 10:46:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415084643.GA21586@elte.hu>
References: <20080411074145.GA4944@elte.hu> <84144f020804142341ic4621c9o6de06d68eee74871@mail.gmail.com> <20080415070811.GA15499@elte.hu> <200804150131.18469.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804150131.18469.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> > why are there no good debug logs possible in this area? To debug 
> > such bugs we'd need an early dump of the precise layout of all 
> > memory maps, what points where, how large it is, where it is 
> > allocated - and then compare it with how the rest of the system is 
> > layed out - looking at possible overlaps or other bugs. This 8-way 
> > box is a pain to debug on, it takes a long time to boot it up, etc. 
> > etc.
> 
> so same config 64 bit with SLUB works and only 32bit is broken? or it 
> 2.6.24 with 32bit + sparse + slub is broken already?

this is a 32-bit-only box.

	Ingo
