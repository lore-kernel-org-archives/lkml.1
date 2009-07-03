Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbZGCGzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbZGCGzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZGCGyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:54:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbZGCGyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:54:54 -0400
Date: Fri, 3 Jul 2009 08:54:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: venkatesh.pallipadi@intel.com
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org, kernel-testers@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [patch 0/4] Take care of cpufreq lockdep issues (take 2)
Message-ID: <20090703065427.GA32687@elte.hu>
References: <20090703000829.735976000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703000829.735976000@intel.com>
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


* venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com> wrote:

> Since recent chanegs to ondemand and conservative governor, there 
> have been multiple reports of lockdep issues in cpufreq. Patch 
> series takes care of these problems.
> 
> This is the next attempt following the one here, which was not a 
> complete fix. 
> http://lkml.indiana.edu/hypermail/linux/kernel/0906.3/01073.html
> 
> I am currently running some stress tests to make sure there are no 
> issues with these patches. But, wanted to send them out for 
> review/comments/testing before I head out for the long weekend.
> 
> If this patchset seems sane, the first patch in the patchset 
> should also get into 30.stable.

Btw., FYI, because my test-systems were frequently triggering those 
bugs, i kept testing the following series from you and Mathieu in 
-tip:

 ecf8b04: cpufreq: Define dbs_mutex purpose and cleanup its usage conservative gov
 b08c597: cpufreq: Define dbs_mutex purpose and cleanup its usage
 0807e30: cpufreq: remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)

So that fix-series, while probably not complete (given that you sent 
a v2 series), worked well in practice and gets my:

 Tested-by: Ingo Molnar <mingo@elte.hu>

Is the delta between this (tested) series and your v2 version 
significant? If not it might make sense to shape it as a delta patch 
to the v1 series, if that looks clean enough - to preserve testing 
results.

	Ingo

