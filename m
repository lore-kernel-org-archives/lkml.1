Return-Path: <linux-kernel-owner+w=401wt.eu-S1763156AbXJPIon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763156AbXJPIon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 04:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757245AbXJPIof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 04:44:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51727 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756466AbXJPIoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:44:34 -0400
Date: Tue, 16 Oct 2007 10:44:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Milton Miller <miltonm@bga.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched domain sysctl: free kstrdup allocations
Message-ID: <20071016084427.GA13571@elte.hu>
References: <20071015074700.GC32064@elte.hu> <mm-sched-2b@bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mm-sched-2b@bga.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.1.7-deb
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2949]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Milton Miller <miltonm@bga.com> wrote:

> The procnames for the cpu and domain were allocated via kstrdup and so 
> should also be freed.  The names for the files are static, but we can 
> differentiate them by the presence of the proc_handler.  If a kstrdup 
> (of < 32 characters) fails the sysctl code will not see the procname 
> or remaining table entries, but any child tables and names will be 
> reclaimed upon free.

thanks, applied.

	Ingo
