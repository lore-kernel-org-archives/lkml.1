Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbZIWMXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbZIWMXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZIWMXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:23:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48456 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbZIWMXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:23:06 -0400
Date: Wed, 23 Sep 2009 14:22:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: checkpatch as a tool (was Re: [RFC][PATCH] SCHED_EDF
	scheduling class)
Message-ID: <20090923122256.GA6390@elte.hu>
References: <1253615424.20345.76.camel@Palantir> <1253625878.6575.34.camel@desktop> <1253628061.20345.173.camel@Palantir> <1253637721.18939.3.camel@laptop> <20090922191117.GB24542@elte.hu> <1253667103.25689.35.camel@desktop> <1253667708.30020.134.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253667708.30020.134.camel@Joe-Laptop.home>
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


* Joe Perches <joe@perches.com> wrote:

> On Tue, 2009-09-22 at 17:51 -0700, Daniel Walker wrote:
> > I'll stop sending those
> > emails if it's actually negative , but I don't think it is..
> 
> Hi Daniel.
> 
> I think it'd be more helpful if instead of merely sending
> a "hah! checkpatch failure!" email you send the submitter
> a gentler nudge and a fixed patch.

He should consider not sending them at all. It's up to maintainers and 
the developers involved with that code whether the small details that 
checkpatch flags are important or not at a given point in the patch 
cycle.

For example i use checkpatch all the time and i think it's a fantastic 
tool, still i dont want another nuisance layer on lkml interfering with 
the patch flow.

If a patch gets so far in the patch cycle that i'm thinking about 
merging it, i might fix the checkpatch failures myself (often they are 
trivial), and i might warn frequent contributors about repeat patterns 
of small uncleanlinesses - or i might bounce the patch back to the 
contributor. I also ignore certain classes of checkpatch warnings.

What Daniel is doing is basically a semi-mandatory checkpatch layer on 
lkml and that's both a distraction and harmful as well. We dont need a 
"checkpatch police" on lkml. We want an open, reasonable, human driven 
patch process with very little buerocracy and no buerocrats.

	Ingo
