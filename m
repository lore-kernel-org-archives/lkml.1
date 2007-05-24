Return-Path: <linux-kernel-owner+w=401wt.eu-S1751151AbXEXOnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbXEXOnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbXEXOm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:42:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41121 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXEXOm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:42:57 -0400
X-Greylist: delayed 1915 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 May 2007 10:42:57 EDT
Date: Thu, 24 May 2007 16:42:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070524144251.GA24859@elte.hu>
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

> > hm, you should only need these:
> > 
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

does it go away if you turn off CONFIG_FUNCTION_TRACE? (that will make 
the trace a lot less verbose, but still informative)

	Ingo
