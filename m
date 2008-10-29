Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbYJ2HFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYJ2HFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 03:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYJ2HFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 03:05:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35084 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYJ2HFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 03:05:46 -0400
Date: Wed, 29 Oct 2008 08:05:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: start annotating early ioremap pointers with
	__iomem
Message-ID: <20081029070537.GF7936@elte.hu>
References: <1225259164.20276.1.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225259164.20276.1.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> As with regular ioremap, iounmap etc, annotate with __iomem.
> 
> Fixes the following sparse warnings, will produce some new ones
> elsewhere in arch/x86 that will get worked out over time.
> 
> arch/x86/mm/ioremap.c:402:9: warning: cast removes address space of expression
> arch/x86/mm/ioremap.c:406:10: warning: cast adds address space to expression (<asn:2>)
> arch/x86/mm/ioremap.c:782:19: warning: Using plain integer as NULL pointer
> 
> Impact: some new sparse warnings in e820.c etc, but no functional change.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/x86/include/asm/io.h |    6 +++---
>  arch/x86/mm/ioremap.c     |   22 +++++++++++-----------
>  2 files changed, 14 insertions(+), 14 deletions(-)

applied to tip/x86/urgent, thanks Harvey!

	Ingo
