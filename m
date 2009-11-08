Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZKHJf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZKHJf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 04:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZKHJf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 04:35:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33171 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZKHJf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 04:35:27 -0500
Date: Sun, 8 Nov 2009 10:35:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Anton Blanchard <anton@samba.org>
Subject: Re: [GIT PULL] perf_event/tracing/powerpc patches from Anton
 Blanchard
Message-ID: <20091108093518.GD21267@elte.hu>
References: <19176.59441.523075.445864@drongo.ozlabs.ibm.com>
 <20091029065501.GB12874@elte.hu>
 <1256882649.6372.65.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256882649.6372.65.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Thu, 2009-10-29 at 07:55 +0100, Ingo Molnar wrote:
> > * Paul Mackerras <paulus@samba.org> wrote:
> > 
> > > Here is a series of patches from Anton Blanchard that implement some 
> > > nice tracing and perf_event features on powerpc.  One of them is 
> > > generic perf_event stuff (adding software events for alignment faults 
> > > and instruction emulation faults).
> > > 
> > > Since this touches the perf_event and tracing subsystems as well as 
> > > the powerpc architecture code, I think the best way forward is for 
> > > both Ingo and Ben to pull it into their trees.  I have based it on the 
> > > most recent point in Linus' tree that Ingo had pulled into his perf 
> > > branches (as of yesterday or so).
> > 
> > The generic perf bits look good to me - can pull it if Ben OKs the 
> > PowerPC bits.
> 
> Yup. Just went through all of them, they look fine. I also test built on
> a number of default configs and it seems to pass.

Pulled into tip:perf/powerpc (will keep it in a separate branch for a 
few days then it can go into perf/core), thanks guys!

	Ingo
