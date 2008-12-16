Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYLPRnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYLPRnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYLPRnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:43:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47557 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbYLPRnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:43:13 -0500
Date: Tue, 16 Dec 2008 18:43:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: add some compile time checks to mem_init()
Message-ID: <20081216174300.GJ11683@elte.hu>
References: <4947A304.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4947A304.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Some of the inconsistencies checked for at run time can be detected at
> build time already, so duplicate the checks done at run time to also be
> done at build time.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/mm/init_32.c |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)

applied to tip/x86/debug - thanks,

	Ingo
