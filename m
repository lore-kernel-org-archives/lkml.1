Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbYJ3V5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbYJ3V5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYJ3V5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:57:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56491 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbYJ3V5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:57:04 -0400
Date: Thu, 30 Oct 2008 22:56:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] fix compile breakage casued by x86: move
	prefill_possible_map calling early
Message-ID: <20081030215652.GH30303@elte.hu>
References: <1225402115.19324.40.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225402115.19324.40.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> >From 2947cdda39c36e5a0d56fe0c6b70a17526abb5b5 Mon Sep 17 00:00:00 2001
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Thu, 30 Oct 2008 15:51:22 -0500
> Subject: [VOYAGER] add prefill_possible_mask() to fix linker breakage
> 
> Before
> 
> commit 329513a35d1a2b6b28d54f5c2c0dde4face8200b
> Author: Yinghai Lu <yhlu.kernel@gmail.com>
> Date:   Wed Jul 2 18:54:40 2008 -0700
> 
>     x86: move prefill_possible_map calling early
> 
> prefill_possible_mask() was hidden under CONFIG_HOTPLUG_CPU rendering
> it invisitble to voyager.  Since this commit it's exposed, but not
> provided by the voyager subarch, so add a dummy stub to fix the link
> breakage.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  arch/x86/mach-voyager/voyager_smp.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

applied to tip/x86/urgent, thanks James!

these kinds of problems will go away too when x86/Voyager becomes part 
of the regular platform code.

	Ingo
