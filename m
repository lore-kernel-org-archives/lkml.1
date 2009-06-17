Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZFQP20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZFQP20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZFQP2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:28:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52818 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbZFQP2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:28:17 -0400
Date: Wed, 17 Jun 2009 17:28:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       Sumit Panchasara <sumit.panchasara@einfochips.com>,
       "'Sachin P Sant'" <sachinp@linux.vnet.ibm.com>,
       "'H. Peter Anvin'" <hpa@zytor.com>, "'Frans Pop'" <elendil@planet.nl>,
       "'Andi Kleen'" <andi@firstfloor.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       "'Balbir Singh'" <balbir@linux.vnet.ibm.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH]x86-tsc.c : fix compile warning
Message-ID: <20090617152802.GB6042@elte.hu>
References: <1245247057.3312.2.camel@myhost> <bb33bcf20906170700i4a4ea802yf1da08e9870d6221@mail.gmail.com> <1245248241.4870.12.camel@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1245248241.4870.12.camel@subratamodak.linux.ibm.com>
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


* Subrata Modak <subrata@linux.vnet.ibm.com> wrote:

> > fix compile warning:
> > arch/x86/kernel/tsc.c: In function ‘time_cpufreq_notifier’:
> > arch/x86/kernel/tsc.c:635: warning: ‘dummy’ may be used uninitialized in
> > this function
> > 
> > Signed-off-by: Figo.zhang <figo1802@gmail.com>
> 
> Hello Figo,
> 
> Please refer to the following links on discussion on this issue earlier:
> http://lkml.org/lkml/2009/5/19/312
> http://lkml.org/lkml/2009/5/19/301
> http://lkml.org/lkml/2009/5/20/23
> 
> I tried to fix it in some other way.

Ah, and you fixed in what a superior way: you improved the code in 
the process :-) This is how warnings should be fixed really.

Applied.

We apparently missed it when you sent it in May - generally feel 
free to re-send patches if you dont see a commit notification within 
a few days.

Thanks,

	Ingo
