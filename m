Return-Path: <linux-kernel-owner+w=401wt.eu-S1751350AbXEXOpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbXEXOpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbXEXOo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:44:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41269 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbXEXOoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:44:55 -0400
Date: Thu, 24 May 2007 16:44:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070524144447.GA25068@elte.hu>
References: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu> <20070524125453.GA7554@elte.hu> <E1HrDuQ-0005m7-00@dorka.pomaz.szeredi.hu> <20070524141059.GA19872@elte.hu> <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.6
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.6 required=5.9 tests=BAYES_00,UPPERCASE_25_50 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.4 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> >  CONFIG_EVENT_TRACE=y
> >  CONFIG_FUNCTION_TRACE=y
> >  # CONFIG_WAKEUP_TIMING is not set
> >  # CONFIG_CRITICAL_IRQSOFF_TIMING is not set
> >  CONFIG_MCOUNT=y
> > 
> > does it boot with these?
> 
> Nope.  Same segfault.  If I try to continue manually with 'init 5', 
> then init segfaults as well :(

could you just try v2.6.21 plus the -rt patch, which has the tracer 
built-in? That's a combination that should work well. You can pick it up 
from:

   http://people.redhat.com/mingo/realtime-preempt/

same config options as above. If you dont turn on PREEMPT_RT you'll get 
an almost-vanilla kernel.

	Ingo
