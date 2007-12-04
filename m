Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbXLDN3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbXLDN3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbXLDN33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:29:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56712 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbXLDN32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:29:28 -0500
Date: Tue, 4 Dec 2007 14:29:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: revert X86_HT semantics change
Message-ID: <20071204132905.GJ31590@elte.hu>
References: <20071115161703.GR4250@stusta.de> <20071115180436.GA23517@uranus.ravnborg.org> <alpine.LFD.0.9999.0711151904300.3112@localhost.localdomain> <20071115181945.GS4250@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115181945.GS4250@stusta.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Adrian Bunk <bunk@kernel.org> wrote:

> The x86 unification resulted in CONFIG_X86_HT no longer being set if 
> (X86_32 && MK8).
> 
> After grep'ing through the tree I think the problem is that different
> places have different assumptions about the semantics of CONFIG_X86_HT,
> either
> - hyperthreading or
> - multicore
> 
> This should be sorted out properly, but until then we should keep the
> 2.6.23 status quo.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

thanks, applied. This is for 2.6.24, right?

	Ingo
