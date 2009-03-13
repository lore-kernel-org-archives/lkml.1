Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbZCMB7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbZCMB7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 21:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZCMB7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 21:59:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40648 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbZCMB7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 21:59:34 -0400
Date: Fri, 13 Mar 2009 02:58:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       trenn@suse.de, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2] x86: mtrr: don't modify RdDram/WrDram bits of fixed
	MTRRs
Message-ID: <20090313015856.GA18760@elte.hu>
References: <20090311150027.GK10490@alberich.amd.com> <20090312163937.GH20716@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312163937.GH20716@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> Impact: bug fix + BIOS workaround

> Change to previous version:
> I slightly modified the log message (e.g. addition of FW_WARN).
> 
> Please consider to apply this patch for .29.

i've applied it to tip:x86/mtrr, thanks Andreas.

I've add a -stable backport tag - so if it's problem-free it 
should show up in .29.1.

It is not completely clear what the impact of this fix is. What 
types of problems are such incoherent MTRR settings causing in 
practice? Boot hang? S2RAM failures? Performance problems?

Without knowing the exact impact we cannot apply it this late in 
the .29.0 cycle - and MTRR code change are dangerous in any case 
so even if we knew the exact scope and impact we'd probably not 
do it in .29.

	Ingo
