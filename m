Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYKTIFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYKTIFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 03:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbYKTIFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 03:05:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47022 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbYKTIFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:05:11 -0500
Date: Thu, 20 Nov 2008 09:04:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Richard A. Holden III" <aciddeath@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Fix arch/x86/kernel/setup.c build warning when
	!CONFIG_X86_RESERVE_LOW_64K
Message-ID: <20081120080457.GC21785@elte.hu>
References: <1227135915-32628-1-git-send-email-aciddeath@gmail.com> <1227135915-32628-2-git-send-email-aciddeath@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227135915-32628-2-git-send-email-aciddeath@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Richard A. Holden III <aciddeath@gmail.com> wrote:

> Fix
> arch/x86/kernel/setup.c:592: warning: 'dmi_low_memory_corruption' defined but not used
> 
> this is only used if CONFIG_X86_RESERVE_LOW_64K is defined.
> 
> Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/kernel/setup.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

applied to tip/x86/memory-corruption-check, thanks Richard!

	Ingo
