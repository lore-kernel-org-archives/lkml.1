Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbZFWTdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbZFWTdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbZFWTdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:33:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35596 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbZFWTde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:33:34 -0400
Date: Tue, 23 Jun 2009 21:32:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "mark.langsdorf@amd.com" <mark.langsdorf@amd.com>
Subject: Re: [PATCH] cpufreq: remove dbs_mutex
Message-ID: <20090623193215.GA31374@elte.hu>
References: <4A2835D8.6040903@kernel.org> <20090611105211.GA6760@elte.hu> <20090620124817.GA22831@elte.hu> <200906212155.49849.trenn@suse.de> <20090623181748.GA31148@elte.hu> <20090623184040.GA6908@elte.hu> <1245783116.4534.17466.camel@localhost.localdomain> <20090623191418.GA14455@elte.hu> <7E82351C108FA840AB1866AC776AEC466972B8C5@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E82351C108FA840AB1866AC776AEC466972B8C5@orsmsx505.amr.corp.intel.com>
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


* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:

> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu] 
> >Sent: Tuesday, June 23, 2009 12:14 PM
> >To: Pallipadi, Venkatesh
> >Cc: Thomas Renninger; Dave Jones; Rusty Russell; Linus 
> >Torvalds; Yinghai Lu; Avi Kivity; Andrew Morton; Thomas 
> >Gleixner; H. Peter Anvin; linux-kernel@vger.kernel.org; 
> >cpufreq@vger.kernel.org; mark.langsdorf@amd.com
> >Subject: Re: [PATCH] cpufreq: remove dbs_mutex
> >
> >
> >* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:
> >
> >> Mathieu Desnoyers sent a patch earlier that should address 
> >this problem.
> >> 
> >> http://lkml.indiana.edu/hypermail/linux/kernel/0906.1/00331.html
> >
> >No, that patch has _not_ fixed the regression:
> >
> >  http://lkml.org/lkml/2009/6/8/563
> >
> 
> The subsequent failure that Dave saw after that patch seemed to be 
> related to dbs_mutex
>
>    http://lkml.org/lkml/2009/6/11/6
> 
> That should be be fixed by your original patch.

And how well will the two mix? This should really be pursued by the 
cpufreq people i think ...

	Ingo
