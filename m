Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbZFQQz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbZFQQz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZFQQzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:55:21 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46170 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbZFQQzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:55:20 -0400
Subject: Re: [PATCH]x86-tsc.c : fix compile warning
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Frans Pop <elendil@planet.nl>, "Figo.zhang" <figo1802@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Sumit Panchasara <sumit.panchasara@einfochips.com>,
       "'Sachin P Sant'" <sachinp@linux.vnet.ibm.com>,
       "'H. Peter Anvin'" <hpa@zytor.com>,
       "'Andi Kleen'" <andi@firstfloor.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       "'Balbir Singh'" <balbir@linux.vnet.ibm.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
In-Reply-To: <20090617162303.GA10158@elte.hu>
References: <1245247057.3312.2.camel@myhost>
	 <1245248241.4870.12.camel@subratamodak.linux.ibm.com>
	 <20090617152802.GB6042@elte.hu> <200906171812.51478.elendil@planet.nl>
	 <20090617162303.GA10158@elte.hu>
Content-Type: text/plain
Organization: IBM
Date: Wed, 17 Jun 2009 22:25:13 +0530
Message-Id: <1245257714.6255.2.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 18:23 +0200, Ingo Molnar wrote:
> * Frans Pop <elendil@planet.nl> wrote:
> 
> > On Wednesday 17 June 2009, Ingo Molnar wrote:
> > > Ah, and you fixed in what a superior way: you improved the code in
> > > the process :-) This is how warnings should be fixed really.
> > 
> > Hmm. Did you also see Pavel's reply to that patch [1]:
> > ! But that's a bug to be fixed, I'd say? ... actually I believe you are
> > ! introducing a bug here. Yes, old code would put random numbers in
> > ! loops_per_jiffy_ref for !CPUFREQ_CONST_LOOPS, but you are introducing
> > ! oops there.
> > 
> > Was his comment incorrect?
> > 
> > Cheers,
> > FJP
> > 
> > [1] http://lkml.org/lkml/2009/5/24/159
> 
> hm, Pavel seems right - i missed that. Subrata, mind sending an 
> updated patch?

Hmmm. I would try doing that soon.

Regards--
Subrata

> 
> Thanks,
> 
> 	Ingo

