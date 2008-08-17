Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYHQMqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYHQMqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbYHQMqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:46:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35137 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbYHQMqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:46:01 -0400
Date: Sun, 17 Aug 2008 14:45:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: hpa@zytor.com, tglx@linutronix.de, macro@linux-mips.org,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: one more apic merging preliminary series
Message-ID: <20080817124540.GF21434@elte.hu>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218914515-26377-1-git-send-email-gorcunov@gmail.com>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Please review - any comments are welcome!
> 
> For now it's like code bloating - but it's just preliminary series to 
> make apic_*.c code more or less similar. And it's still a bit far from 
> being ready to be merged down.

applied to tip/x86/apic - thanks Cyrill.

Maciej's point about cleaning up the x2apic impact is very much true - 
i've Cc:-ed Suresh and Venki. Even if we wont truly use x2apic in 32-bit 
kernels, it's a piece of glue hardware that does not depend on which 
mode the CPU is in, so support for it should be bitsize agnostic. It 
will also obviously be good for test coverage, once x2apic capable hw 
will be more widespread.

	Ingo
