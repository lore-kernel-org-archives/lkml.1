Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbZCJWh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbZCJWh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbZCJWhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:37:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58290 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891AbZCJWhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:37:46 -0400
Date: Tue, 10 Mar 2009 23:37:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 00/13] convert voyager over to the x86 quirks model
Message-ID: <20090310223733.GA4016@elte.hu>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Given the lack of feedback, I went ahead and implemented the 
> additions to smp_ops and x86_quirks (and a dynamic mca NMI 
> hook) to allow voyager to be plumbed in.
> 
> There also needs to be changes in the boot setup to make 
> voyager work dynamically: It has to be detected first, so the 
> a20 gate check is only executed if a voyager is not found.
> 
> I also completed some of the subarchitecture eliminations, so 
> all the include file infrastructure should be gone.
> 
> The result is that I can boot both my PC SMP x86 boxes and 
> voyager with the same kernel.
> 
> This patch series applies on the x86/apic branch of the x86 
> tree (obviously with 965c7ecaf2e2b083d711a01ab33735a4bdeee1a4 
> reverted)

The question is, why would we want to merge Voyager back ever 
again?

The hardware is obsolete and is not being produced anymore, 
nobody but you uses development kernels on it, and it caused all 
sorts of x86 maintenance overhead all along. It did not even 
build since August 2008, up until the point we removed it - 
2.6.26.0 was the last time it built.

	Ingo
