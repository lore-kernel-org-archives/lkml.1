Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbYHTKgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbYHTKgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYHTKgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:36:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50216 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbYHTKge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:36:34 -0400
Date: Wed, 20 Aug 2008 12:36:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] SGI UV: hardcode the TLB flush interrupt system vector
Message-ID: <20080820103621.GC2816@elte.hu>
References: <E1KVVN9-0006fS-4Z@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KVVN9-0006fS-4Z@eag09.americas.sgi.com>
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
> The UV TLB shootdown mechanism needs a system interrupt vector.
> 
> Its vector had been hardcoded as 200, but needs to moved to the 
> reserved system vector range so that it does not collide with some 
> device vector.
> 
> This is still temporary until dynamic system IRQ allocation is 
> provided. But it will be needed when real UV hardware becomes 
> available and runs 2.6.27.

applied to tip/x86/urgent, thanks Cliff.

	Ingo
