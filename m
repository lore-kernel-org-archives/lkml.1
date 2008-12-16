Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758352AbYLPVyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbYLPVyg (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 16:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYLPVy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:54:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54181 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbYLPVy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:54:26 -0500
Date: Tue, 16 Dec 2008 22:54:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 : UV fix for global physical addresses
Message-ID: <20081216215414.GX14787@elte.hu>
References: <20081212205040.GA25739@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212205040.GA25739@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> This fixes a UV bug related to generating global memory addresses
> on partitioned systems. Partition systems do not have physical memory
> at address 0. Instead, a chunk of high memory is remapped by the chipset
> so that it appears to be at address 0. This remapping is INVISIBLE to most
> of the OS. The only OS functions that need to be aware of the remaping are
> functions that directly interface to the chipset. The GRU is one example.
> 
> Also, delete a couple of unused macros related to global memory addresses.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> 
> ---
>  arch/x86/include/asm/uv/uv_hub.h |   16 ++--------------
>  arch/x86/kernel/genx2apic_uv_x.c |    3 +--
>  2 files changed, 3 insertions(+), 16 deletions(-)

applied to tip/x86/uv, thanks Jack!

	Ingo
