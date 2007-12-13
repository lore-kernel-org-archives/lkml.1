Return-Path: <linux-kernel-owner+w=401wt.eu-S1760835AbXLMKRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835AbXLMKRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 05:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXLMKRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 05:17:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48058 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbXLMKRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 05:17:33 -0500
Date: Thu, 13 Dec 2007 11:17:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, venkatesh.pallipadi@intel.com
Subject: Re: [crash] kernel BUG at drivers/cpufreq/cpufreq.c:1060!
Message-ID: <20071213101711.GN8977@elte.hu>
References: <20071212091144.GA11986@elte.hu> <20071212164013.GA2359@redhat.com> <20071212181828.GA27675@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212181828.GA27675@redhat.com>
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


* Dave Jones <davej@redhat.com> wrote:

>  > It _looks_ like we're leaking a refcount on that lock, but I don't 
>  > see where.  It's a shame you can't reproduce this easily, as 
>  > cpufreq.debug=7 would give us more clues. (And 
>  > CONFIG_CPUFREQ_DEBUG=y)
> 
> So we're missing some unlocks in some error paths. It's feasible you 
> hit one of those. This patch should be the fix for that.

since it's not really reproducible (i failed to get it since then), how 
about you push your fix upstream (it's an obviously correct fix), we 
consider this regression fixed and i'll re-notify you if there's still 
any problem left. It's not like there's any escape from make randconfig 
bootup test coverage in the long run ;-)

	Ingo
