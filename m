Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYFYQAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYFYQAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYFYQAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:00:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37678 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbYFYQAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:00:30 -0400
Date: Wed, 25 Jun 2008 18:00:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softlockup: show irqtrace
Message-ID: <20080625160016.GA24967@elte.hu>
References: <20080625071323.GA7987@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625071323.GA7987@damson.getinternet.no>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi,
> 
> Ingo, can you please drop the "softirq softlockup debugging" patch and 
> apply this instead? This much, much prettier, reuses existing 
> debugging infrastructure, and is a lot more generic.

applied to tip/core/softlockup, thanks Vegard.

> (Compile tested on allyesconfig, allnoconfig, allnoconfig + softlockup 
> debugging.)

hm, that must have taken quite some time to do on your desktop, right?

FYI, there's no mandatory need to go through that buerocratic testing 
hassle with patches submitted to -tip - especially with small patches 
that look obvious and have a high chance of being right. We do non-stop 
allyes/allno/allmod+randconfig 64-bit/32-bit build and boot testing for 
every single patch added to the repository.

Building, booting and testing it in the environment where you expect it 
to be used primarily should be more than enough.

	Ingo
