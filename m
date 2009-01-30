Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZA3PDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZA3PDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZA3PDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:03:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43523 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbZA3PDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:03:03 -0500
Date: Fri, 30 Jan 2009 16:02:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: [PATCH] x86: UV fix uv_flush_send_and_wait
Message-ID: <20090130150257.GA27549@elte.hu>
References: <E1LSeXm-0007ck-9j@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LSeXm-0007ck-9j@eag09.americas.sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> uv_flush_send_and_wait() should return a pointer if the broadcast
> remote tlb shootdown requests fail. That causes the conventional IPI
> method of shootdown to be used.
> 
> Diffed against 2.6.29-rc2
>   (Ingo's tree)
> 
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> ---
>  arch/x86/kernel/tlb_uv.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to tip/x86/urgnet, thanks Cliff!

	Ingo
