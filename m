Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYGRGwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYGRGwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 02:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYGRGwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 02:52:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37581 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbYGRGwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 02:52:45 -0400
Date: Fri, 18 Jul 2008 08:52:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] percpu: Optimize percpu accesses
Message-ID: <20080718065224.GA6875@elte.hu>
References: <20080701121634.865966000@polaris-admin.engr.sgi.com> <20080701145417.GB18522@elte.hu> <20080701150313.GA30476@elte.hu> <486A483B.2090804@sgi.com> <486B8AD3.70007@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486B8AD3.70007@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Mike Travis wrote:
> > Ingo Molnar wrote:
> >> * Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >>>> This patchset provides the following:
> >>>>
> >>>>   * Cleanup: Fix early references to cpumask_of_cpu(0)
> >>>>   * Generic: Percpu infrastructure to rebase the per cpu area to zero
> >>>>   * x86_64: Fold pda into per cpu area
> >>>>   * x86_64: Rebase per cpu variables to zero
> >>> thanks Mike - i've started testing it in -tip. One small merge fallout 
> >>> fix is below. (it's for the new generic-ipi topic that was not in 
> >>> tip/master yet when you merged percpu-zerobased to it)
> >> ok, -tip testing found an early boot crash caused by your patchset, on 
> >> 64-bit x86:
> 
> Hi Ingo,
> 
> Which gcc version are you using?

vanilla gcc-4.2.3 (unpatched).

	Ingo
