Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbXDQJAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbXDQJAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 05:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbXDQJAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 05:00:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57950 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbXDQJAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 05:00:16 -0400
Date: Tue, 17 Apr 2007 10:59:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417085936.GB16645@elte.hu>
References: <20070416220715.GA4071@elte.hu> <200704170112.35819.caglar@pardus.org.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704170112.35819.caglar@pardus.org.tr>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> 17 Nis 2007 Sal tarihinde, Ingo Molnar şunları yazmıştı: 
> >  - fixed child-runs first. A /proc/sys/kernel/sched_child_runs_first
> >    flag can be used to turn it on/off. (This might fix the Kaffeine bug
> >    reported by S.Çağlar Onur <)
> 
> Sorry for delayed response but i just find some free time, do you 
> still want me to test mainline + "parent-runs first" patch or will i 
> drop that one and test v2 which can change default behaviour?

i suspect for now it would be sufficient if you could check the v2 
patch.

if it _works_, please try this:

    echo 0 > /proc/sys/kernel/sched_child_runs_first

this should break Kaffeine again :)

(if it doesnt work then the Kaffeine problem is unrelated to 
child-runs-first.)

	Ingo
