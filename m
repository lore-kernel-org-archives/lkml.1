Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbZL1KAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbZL1KAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZL1KAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:00:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60632 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbZL1KAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:00:49 -0500
Date: Mon, 28 Dec 2009 11:00:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sf.net,
       tglx@linutronix.de
Subject: Re: [PATCH] x86, perfctr: remove unused func
 avail_to_resrv_perfctr_nmi()
Message-ID: <20091228100020.GA730@elte.hu>
References: <20091224015441.6005.4408.sendpatchset@localhost.localdomain>
 <20091224150458.GA5143@lenovo>
 <20091228083845.GK28652@elte.hu>
 <20091228095546.GA4884@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091228095546.GA4884@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> > Not that i know of.
> 
> ok, then we could apply this patch I think, at least for a while.

yeah, i have applied it.

> > In fact we should transform/migrate the NMI watchdog driver by making it 
> > based on a kernel-internal created perf event. (which is what the NMI 
> > watchdog really is: a periodic NMI event occuring once per second and 
> > running a callback function.)
> 
> Yes, this would be great. I'll try to find out some time for this task, 
> though no promises :) If someone get it done earlier I would really 
> appreciate.

Feel free to do it. We could do it gradual. Maybe we could also then gradually 
remove perfctr code for CPU variants that already have perf events support. 

Plus later on we could carefully identify bits of APIC support code in 
perfctr.c and turn those into minimal perf events PMU drivers.

	Ingo
