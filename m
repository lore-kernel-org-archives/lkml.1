Return-Path: <linux-kernel-owner+w=401wt.eu-S1758658AbYJ3Sjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbYJ3Sjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbYJ3Sjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:39:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56456 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbYJ3Sjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:39:36 -0400
Date: Thu, 30 Oct 2008 19:39:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1]: SGI x86 UV: Fix compile error in uv_hub.h
Message-ID: <20081030183924.GB17822@elte.hu>
References: <4909FDEF.2050803@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4909FDEF.2050803@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Subject: SGI x86 UV: Fix compile error in uv_hub.h
> 
> Fix compile errors of files that include asm/uv/uv_hub.h but do
> not include linux/timer.h.
> 
> Based on linux-next.
> 
> Signed-of-by: Mike Travis <travis@sgi.com>
> ---
>  arch/x86/include/asm/uv/uv_hub.h |    1 +
>  1 file changed, 1 insertion(+)

does not affect mainline currently, correct? Nevertheless i queued it 
up in x86/urgent as it's an obviously correct dependency fix.

	Ingo
