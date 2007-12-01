Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbXLAThZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbXLAThZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 14:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbXLAThJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 14:37:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60965 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbXLAThH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 14:37:07 -0500
Date: Sat, 1 Dec 2007 20:36:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071201193643.GA10911@elte.hu>
References: <20071201092037.GA32544@elte.hu> <alpine.DEB.0.9999.0712011036340.10996@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.9999.0712011036340.10996@chino.kir.corp.google.com>
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


* David Rientjes <rientjes@google.com> wrote:

> > this patch extends the soft-lockup detector to automatically detect 
> > hung TASK_UNINTERRUPTIBLE tasks. Such hung tasks are printed the 
> > following way:
> 
> Wouldn't a natural extension of this feature be to mark these hung 
> TASK_UNINTERRUPTIBLE tasks with a new thread flag such as TIF_HUNG for 
> the purposes of the OOM killer?

maybe, but we'd have to see how often this gets triggered. An OOM is 
something that could happen in any overloaded system - while a hung task 
is likely due to a kernel bug.

	Ingo
