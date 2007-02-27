Return-Path: <linux-kernel-owner+w=401wt.eu-S932942AbXB0KWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbXB0KWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932948AbXB0KWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:22:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44702 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbXB0KWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:22:17 -0500
Date: Tue, 27 Feb 2007 11:14:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bunk@stusta.de, pavel@suse.cz, linux-pm@linux-foundation.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com, mingo@redhat.com
Subject: Re: 2.6.21-rc1: T60 resume from suspend to RAM issues
Message-ID: <20070227101451.GA11981@elte.hu>
References: <20070223020904.c8fc8a3e.akpm@linux-foundation.org> <20070224211141.GA4425@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070224211141.GA4425@mellanox.co.il>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.1.7
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2424]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@mellanox.co.il> wrote:

> > > 2. As a separate test, I enabled DynTicks in .config. Seems to 
> > > work fine but won't come out of suspend to memory at all: pressing 
> > > Fn/F4 seems to have no effect.
> > 
> > Do you believe that the second problem was caused by dynticks?
> 
> Assuming these are 2 different problems, yes, the second one seems to 
> be caused by dyntics.

on my T60 current -git does not resume even without dynticks. v2.6.20 
with the same .config resumes fine (except for the display).

after pressing Fn/F4 the disk light flashes briefly, which suggests that 
action is probably back to the Linux kernel at that point, and that we 
hung somewhere there. Will try a bisection thing.

	Ingo
