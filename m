Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbZFQQXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbZFQQXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbZFQQXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:23:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54871 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757375AbZFQQXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:23:19 -0400
Date: Wed, 17 Jun 2009 18:23:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>,
       "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       Sumit Panchasara <sumit.panchasara@einfochips.com>,
       "'Sachin P Sant'" <sachinp@linux.vnet.ibm.com>,
       "'H. Peter Anvin'" <hpa@zytor.com>,
       "'Andi Kleen'" <andi@firstfloor.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       "'Balbir Singh'" <balbir@linux.vnet.ibm.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH]x86-tsc.c : fix compile warning
Message-ID: <20090617162303.GA10158@elte.hu>
References: <1245247057.3312.2.camel@myhost> <1245248241.4870.12.camel@subratamodak.linux.ibm.com> <20090617152802.GB6042@elte.hu> <200906171812.51478.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906171812.51478.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frans Pop <elendil@planet.nl> wrote:

> On Wednesday 17 June 2009, Ingo Molnar wrote:
> > Ah, and you fixed in what a superior way: you improved the code in
> > the process :-) This is how warnings should be fixed really.
> 
> Hmm. Did you also see Pavel's reply to that patch [1]:
> ! But that's a bug to be fixed, I'd say? ... actually I believe you are
> ! introducing a bug here. Yes, old code would put random numbers in
> ! loops_per_jiffy_ref for !CPUFREQ_CONST_LOOPS, but you are introducing
> ! oops there.
> 
> Was his comment incorrect?
> 
> Cheers,
> FJP
> 
> [1] http://lkml.org/lkml/2009/5/24/159

hm, Pavel seems right - i missed that. Subrata, mind sending an 
updated patch?

Thanks,

	Ingo
