Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbYJVGji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbYJVGji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 02:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJVGja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 02:39:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYJVGja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 02:39:30 -0400
Date: Wed, 22 Oct 2008 08:39:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Russ Anderson <rja@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Use consistent names for region size and
	conherence id on x86 and ia64.
Message-ID: <20081022063917.GA17485@elte.hu>
References: <20081021190951.GA51519@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021190951.GA51519@sgi.com>
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


* Russ Anderson <rja@sgi.com> wrote:

> Use consistent names for region size and conherence id on x86 and ia64.
> 
> Signed-off-by: Russ Anderson <rja@sgi.com>
> 
> ---
> The SGI xp drivers are used on both ia64 and x86.  Using the same
> names (sn_coherency_id, sn_region_size) simplies the driver code.
> 
> 
> 
>  arch/x86/kernel/bios_uv.c        |    8 ++++----
>  arch/x86/kernel/genx2apic_uv_x.c |    4 ++--
>  include/asm-x86/uv/bios.h        |    6 +++---
>  3 files changed, 9 insertions(+), 9 deletions(-)

applied to tip/x86/uv, thanks Russ!

	Ingo
