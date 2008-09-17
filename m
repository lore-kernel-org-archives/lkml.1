Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYIQJ40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYIQJ40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 05:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYIQJ4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 05:56:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54228 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbYIQJ4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 05:56:17 -0400
Date: Wed, 17 Sep 2008 11:55:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, torvalds@linux-foundation.org
Subject: Re: [2.6.27-rc6 regression] Intermittent boot problem with
	2.6.27-rc6
Message-ID: <20080917095558.GB7040@elte.hu>
References: <20080916200414.GB16993@localdomain> <1221639786.25574.27.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221639786.25574.27.camel@ymzhang>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> 
> On Tue, 2008-09-16 at 13:04 -0700, Ravikiran G Thirumalai wrote:
> > Hi,
> > Booting 2.6.27-rc6, or the current Linus' git on large x86_64 NUMA wedges
> > intermittently.  This happens on machines with more than 4 NUMA nodes.  The
> > same kernel boots on similar hardware with fewer NUMA nodes (or boards).
> > 2.6.27-rc3 seemed to boot well on similar configurations, so looks like a
> > regression crept in between 2.6.27-rc3 and rc6.
> > 
> > I am trying a few things -- commandline options to eliminate popular
> > suspects (such as unsynced tsc clocksources)  as well as git bisect, but
> > wanted to report the regression in the meanwhile.
> > Here's the dmesg of a 24 core 6 node wedged system.
> Because the git doesn't include my patch. Pls. try it.
> 
> http://marc.info/?l=linux-kernel&m=122093094701219&w=2

it's queued up already, will send a pull request later today.

	Ingo
