Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbYAHWNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbYAHWNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYAHWM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:12:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38440 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbYAHWM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:12:56 -0500
Date: Tue, 8 Jan 2008 23:12:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: enable irq in default_idle
Message-ID: <20080108221238.GB21482@elte.hu>
References: <4782984F.3050601@ct.jp.nec.com> <20080108080419.GD31838@elte.hu> <4783AFE5.6040102@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4783AFE5.6040102@ct.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> >> local_irq_enable() is missing after 
> >> sched_clock_idle_wakeup_event().
> > 
> > thanks Hiroshi, applied.
> > 
> > The effects of this bug should be increased latencies on 64-bit. Did 
> > you notice these latencies, or did you find the bug in some other 
> > way (code review)?
> 
> I found this when I was comparing 32-bit and 64-bit source code for 
> x86 unification.

cool :) Indeed even for other code, a number of times we got bugfixes 
when unifying 32-bit and 64-bit files.

	Ingo
