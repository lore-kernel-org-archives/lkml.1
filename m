Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbYBDNFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbYBDNFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbYBDNEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:04:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42581 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbYBDNEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:04:32 -0500
Date: Mon, 4 Feb 2008 14:04:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-git4+ regression
Message-ID: <20080204130418.GB8730@elte.hu>
References: <20080130135609.GA5100@ics.muni.cz> <20080131102919.GC27157@elte.hu> <20080204111747.GB4450@ics.muni.cz> <20080204120131.GA20962@elte.hu> <20080204122900.GA4287@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204122900.GA4287@ics.muni.cz>
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


* Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:

> On Mon, Feb 04, 2008 at 01:01:32PM +0100, Ingo Molnar wrote:
> > 
> > * Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:
> > 
> > > but in such a case, kernel 2.6.24-git13 does oops at startup in 
> > > sched_slice.
> > 
> > could you tell me more about this oops? You booted unmodified, latest 
> > -git and it oopsed in sched_slice()? The patch below should work around 
> > any oopses in sched_slice(). [but this is really a 'must not happen' 
> > scenario - so a just-for-testing patch]
> 
> No, I booted modified lates git to see if mentioned patch (revertin 
> slices) solves horrible non-interactivy problem. With your fix, I can 
> boot now but the patch did not help. Make -j2 in kernel sources 
> significantly decreases interactivity. Any ideas?

yes, please run latencytop - does it pinpoint any latency source? Enable 
CONFIG_LATENCYTOP in the -git13 kernel and run the utility from 
latencytop.org. Also, please send me the output of this script:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

	Ingo
