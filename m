Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbXJDIDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbXJDIDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 04:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXJDIDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 04:03:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53303 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbXJDIDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 04:03:06 -0400
Date: Thu, 4 Oct 2007 10:02:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Kravetz <kravetz@us.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: -rt scheduling: wakeup bug?
Message-ID: <20071004080217.GE9176@elte.hu>
References: <20071001221519.GA20671@monkey.ibm.com> <20071002050632.GB28345@elte.hu> <20071003173705.GB4817@monkey.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003173705.GB4817@monkey.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Kravetz <kravetz@us.ibm.com> wrote:

> >  	if (rq->curr && p && rq && _need_resched())
> >  		trace_special_pid(p->pid, PRIO(p), PRIO(rq->curr));
> 
> Not an issue with the patch, just that last bit of code pulled in for 
> context.  I don't think it is a bug, but the checking of 'rq' after 
> checking 'rq->curr' just doesn't look right (or necessary).  Could it 
> just be an artifact from earlier versions of the code?

yeah, you are right - and rq shouldnt ever be NULL there anyway.

	Ingo
