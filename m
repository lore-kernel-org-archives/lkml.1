Return-Path: <linux-kernel-owner+w=401wt.eu-S932465AbYEGIdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbYEGIdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbYEGIdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:33:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45507 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762905AbYEGIdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:33:14 -0400
Date: Wed, 7 May 2008 10:32:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Parag Warudkar <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: Horrendous Audio Stutter - current git
Message-ID: <20080507083258.GB22821@elte.hu>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com> <1209717278.13978.136.camel@twins> <200805071026.29540.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805071026.29540.elendil@planet.nl>
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


* Frans Pop <elendil@planet.nl> wrote:

> On Friday 02 May 2008, Peter Zijlstra wrote:
> > > Under kernel compilation load (make -j8) audio is very much unusable
> > > on current linux-2.6.git - The stutter is so bad I can hardly tell
> > > what song I am listening to :)
> > > Even with make -j4 it still skips but not that badly.
> 
> What's the current status here?
> With mainline v2.6.26-rc1-110-ga153063 (which has latest sched 
> patches), I still get very bad audio skips with GROUP_SCHED enabled.

there's no solution for now, the latency targets are still not working 
under the group scheduler. Upstream we've made it non-default and marked 
it EXPERIMENTAL.

Peter has a new updated group scheduler queue that i'm testing right 
now, perhaps it can be pushed out to sched-devel/latest later today. But 
that is v2.6.27 material.

	Ingo
