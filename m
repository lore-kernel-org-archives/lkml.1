Return-Path: <linux-kernel-owner+w=401wt.eu-S1763213AbXGYLl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763213AbXGYLl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760195AbXGYLlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:41:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45086 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759785AbXGYLlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:41:50 -0400
Date: Wed, 25 Jul 2007 13:41:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Henri Hunnekens <henrihunnekens@gmail.com>
Cc: Joachim Deguara <joachim.deguara@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: TSC calibration sometimes not correct with RT patch.
Message-ID: <20070725114142.GB26882@elte.hu>
References: <e9f486400707250025k163d34cdk97cf2722db739634@mail.gmail.com> <20070725073949.GB595@elte.hu> <e9f486400707250056i7f6ef2aducef8c0f7cf11c09c@mail.gmail.com> <200707251230.24311.joachim.deguara@amd.com> <e9f486400707250439k432d8b6dwb9c3066d7152f0dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9f486400707250439k432d8b6dwb9c3066d7152f0dd@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Henri Hunnekens <henrihunnekens@gmail.com> wrote:

> That was also my first idea, however the local_irq_disable() routine 
> disables the interrupts according to Ingo, so an SMI is not possible.

both NMIs and SMIs are still possible even in a CLI-ed section.

	Ingo
