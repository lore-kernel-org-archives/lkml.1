Return-Path: <linux-kernel-owner+w=401wt.eu-S1751277AbXEXOLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbXEXOLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXEXOLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:11:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38766 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbXEXOLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:11:04 -0400
Date: Thu, 24 May 2007 16:10:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070524141059.GA19872@elte.hu>
References: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu> <20070524125453.GA7554@elte.hu> <E1HrDuQ-0005m7-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HrDuQ-0005m7-00@dorka.pomaz.szeredi.hu>
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


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> > how reproducable are these lockups - could you possibly trace it? If 
> > yes then please apply:
> > 
> >   http://www.tglx.de/private/tglx/ht-debug/tracer.diff
> 
> With this patch boot stops at segfaulting fsck.  I enabled all the new 
> config options, is that not a good idea?  Which one exactly do I need?

hm, you should only need these:

 CONFIG_EVENT_TRACE=y
 CONFIG_FUNCTION_TRACE=y
 # CONFIG_WAKEUP_TIMING is not set
 # CONFIG_CRITICAL_IRQSOFF_TIMING is not set
 CONFIG_MCOUNT=y

does it boot with these?

	Ingo
