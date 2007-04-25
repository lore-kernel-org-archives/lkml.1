Return-Path: <linux-kernel-owner+w=401wt.eu-S2992524AbXDYJpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992524AbXDYJpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992530AbXDYJpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:45:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33583 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992529AbXDYJpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:45:08 -0400
Date: Wed, 25 Apr 2007 11:44:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070425094403.GA3290@elte.hu>
References: <20070424212717.GR31925@holomorphy.com> <5FD5754DDBA0B1499B5A0B4BB5419485F72D3C@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FD5754DDBA0B1499B5A0B4BB5419485F72D3C@fmsmsx411.amr.corp.intel.com>
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


* Li, Tong N <tong.n.li@intel.com> wrote:

> [...] A corollary of this is that if both threads i and j are 
> continuously runnable with fixed weights in the time interval, then 
> the ratio of their CPU time should be equal to the ratio of their 
> weights. This definition is pretty restrictive since it requires the 
> properties to hold for any thread in any interval, which is not 
> feasible. [...]

yes, it's a pretty strong definition, but also note that while it is 
definitely not easy to implement, the solution is nevertheless feasible 
in my opinion and there exists a scheduler that implements it: CFS.

	Ingo
