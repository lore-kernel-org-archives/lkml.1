Return-Path: <linux-kernel-owner+w=401wt.eu-S1758999AbZCTS43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbZCTS43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZCTS4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:56:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46139 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZCTS4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:56:19 -0400
Date: Fri, 20 Mar 2009 19:55:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Subject: Re: [patch] x86, bts: use atomic memory allocation
Message-ID: <20090320185559.GA6224@elte.hu>
References: <20090318192700.A6038@sedona.ch.intel.com> <20090319161141.GA12144@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E923FFCA4@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E923FFCA4@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu]
> >Sent: Thursday, March 19, 2009 5:12 PM
> >To: Metzger, Markus T
> 
> 
> >> Ds_request_bts() needs to allocate memory. It uses GFP_KERNEL.
> >>
> >> Hw-branch-tracer calls ds_request_bts() within on_each_cpu().
> >>
> >> Use atomic memory allocation to allow it to be used in that context.
> >
> >the hw-branch-tracer still crashes during bootup. Have you tried the
> >config i sent to you, and have you tried to reproduce it? I've
> >attached another config that crashes.
> 
> The first config boots OK.

> The second config boots OK with the additional changes to keep the 
> GFP_KERNEL and move the ds_request_bts() calls out of the 
> on_each_cpu() in the hw-branch-tracer.
> 
> I don't know yet what exactly causes the crash and if there is a 
> simpler fix.

hm, this was an AMD box - so perhaps they dont have a compatible DS 
implementation?

	Ingo
