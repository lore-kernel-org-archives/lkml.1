Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbZBPIiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbZBPIiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 03:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbZBPIie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 03:38:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43826 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327AbZBPIie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 03:38:34 -0500
Date: Mon, 16 Feb 2009 09:38:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make APIC_init_uniprocessor() more like
	smp_prepare_cpus()
Message-ID: <20090216083826.GD6182@elte.hu>
References: <49991D32.6070409@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49991D32.6070409@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: cleanup
> 
> 1. move localise_nmi_watchdgoe() later
> 2. change setup_boot_APIC_clock to setup_boot_clock for 64bit
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/kernel/apic.c |   20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)

Applied to tip:x86/apic, thanks Yinghai!

	Ingo
