Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbYLUINR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbYLUINR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 03:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYLUIND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 03:13:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54837 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYLUINB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 03:13:01 -0500
Date: Sun, 21 Dec 2008 09:11:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chris Snook <csnook@redhat.com>, Kumar Gala <galak@kernel.crashing.org>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Scott Wood <scottwood@freescale.com>
Subject: Re: [Bug #11849] default IRQ affinity change in v2.6.27 (breaking
	several SMP PPC based systems)
Message-ID: <20081221081150.GA4773@elte.hu>
References: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera> <vy-yJy0f3YP.A.x9B.8cYTJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vy-yJy0f3YP.A.x9B.8cYTJB@chimera>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11849
> Subject		: default IRQ affinity change in v2.6.27 (breaking several SMP PPC based systems)
> Submitter	: Kumar Gala <galak@kernel.crashing.org>
> Date		: 2008-10-24 12:45 (58 days old)
> References	: http://marc.info/?l=linux-kernel&m=122485245924125&w=4

hm, i think these were all fixed a long time ago, via:

 f6d87f4: genirq: keep affinities set from userspace across free/request_irq()
 612e368: genirq: fix the affinity setting in setup_irq
 6c2e940: x86: apic honour irq affinity which was set in early boot

Kumar, could you please check v2.6.28-rc9 to see whether all issues are 
fixed?

	Ingo
