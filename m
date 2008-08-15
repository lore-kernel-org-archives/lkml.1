Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbYHOL7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbYHOL7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 07:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYHOL7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 07:59:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35643 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbYHOL7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 07:59:37 -0400
Date: Fri, 15 Aug 2008 13:59:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Aristeu Rozanski <arozansk@redhat.com>
Cc: linux-kernel@vger.kernel.org, jvillalovos@redhat.com
Subject: Re: [PATCH] perfctr: don't use CCCR_OVF_PMI1 on Pentium 4Ds
Message-ID: <20080815115928.GD32726@elte.hu>
References: <20080814203133.GS7154@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814203133.GS7154@redhat.com>
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


* Aristeu Rozanski <arozansk@redhat.com> wrote:

> Currently, setup_p4_watchdog() use CCCR_OVF_PMI1 to enable the counter 
> overflow interrupts to the second logical core. But this bit doesn't 
> work on Pentium 4 Ds (model 4, stepping 4) and this patch avoids its 
> use on these processors. [...]

btw., what was the effect - an oops on bootup, or a non-working 
watchdog?

> [...] Tested on 4 different machines that have this specific model 
> with success.
> 
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>

applied to tip/x86/urgent - thanks Aristeu.

	Ingo
