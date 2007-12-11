Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbXLKRES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbXLKRES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbXLKRD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:03:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58335 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbXLKRD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:03:58 -0500
Date: Tue, 11 Dec 2007 18:03:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: dor.laor@qumranet.com, tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: Performance overhead of get_cycles_sync
Message-ID: <20071211170334.GA30144@elte.hu>
References: <475E8C8B.7070308@qumranet.com> <20071211133738.GA8150@elte.hu> <475E9A92.4030001@qumranet.com> <20071211142717.GA15903@elte.hu> <20071211083513.56c2a385@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211083513.56c2a385@laptopd505.fenrus.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> > * Dor Laor <dor.laor@gmail.com> wrote:
> > 
> > The patch below should resolve this - could you please test and Ack 
> > it? But this CPUID was present in v2.6.23 too, so why did it only 
> > show up in 2.6.24-rc for you?
> 
> isn't this probably wrong since this code is also used in the vsyscall 
> code..

the TSC clocksource (and hence the vsyscall code) is turned off on 
systems that fail the TOD/CLOCK portion of this test:

  http://people.redhat.com/mingo/time-warp-test/time-warp-test.c

i.e. on the majority of systems in place.

	Ingo
