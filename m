Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbYDGMdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbYDGMdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 08:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbYDGMdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 08:33:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53458 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbYDGMdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 08:33:06 -0400
Date: Mon, 7 Apr 2008 14:32:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rc8] Regression: key repeats and skips in music during
	compilation
Message-ID: <20080407123234.GA8521@elte.hu>
References: <200804041222.35025.elendil@planet.nl> <200804071229.27113.rjw@sisk.pl> <20080407112459.GA11532@linux.vnet.ibm.com> <200804071403.59500.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804071403.59500.elendil@planet.nl>
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

> > I thought we had most of the issues ironed out.
> 
> Note that I can also reproduce the issue with a kernel that does *not* 
> have CONFIG_GROUP_SCHED set. I still get the music skips (maybe less 
> frequently, but that's hard to measure), and I've have also seen key 
> repeats once.
> 
> Anything I can do to provide additional info on this?

yes, if you have an audio skipping bug, there's a mini-howto at:

 http://people.redhat.com/mingo/sched-devel.git/howto-debug-latencies.txt

and a more laborous way would be to trace such skipping:

 http://people.redhat.com/mingo/sched-devel.git/howto-trace-latencies.txt

	Ingo
