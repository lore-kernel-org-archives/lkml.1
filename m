Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZCFPYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZCFPYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZCFPYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:24:02 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35439 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbZCFPYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:24:00 -0500
Date: Fri, 6 Mar 2009 16:23:49 +0100
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
Subject: Re: [patch 1/4] x86, bts: add selftest for BTS
Message-ID: <20090306152349.GC12066@elte.hu>
References: <20090305161711.A16434@sedona.ch.intel.com> <20090306143237.GC21907@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E4A5A120A@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E4A5A120A@irsmsx504.ger.corp.intel.com>
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
> >Sent: Friday, March 06, 2009 3:33 PM
> >To: Metzger, Markus T
> 
> 
> >> +#ifdef CONFIG_X86_DS_SELFTEST
> >> +static int ds_selftest_bts_consistency(const struct bts_trace *trace)
> >
> >Consider putting this into ds_selftest.c instead of adding a
> >large #ifdef block to ds.c.
> 
> 
> Thanks for your comments.
> 
> I will correct the style problems, move this into 
> ds_selftest.c, and resend the entire series next week.

Thanks! I picked up the .29 items, so there's no rush.

	Ingo
