Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYLLJBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYLLJBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758505AbYLLJBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:01:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46367 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007AbYLLJBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:01:03 -0500
Date: Fri, 12 Dec 2008 10:00:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/fastboot: fix len of func buffer
Message-ID: <20081212090054.GD25106@elte.hu>
References: <49412D50.8090102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49412D50.8090102@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> Impact: fix possible stack overrun
> 
> This is a port of a patch included in the mainline (KSYM_SYMBOL_LEN fixes).
> The current func len is not large enough to contain the max symbol len, the
> right size must be KSYM_SYMBOL_LEN.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

thanks Frederic and Stephen, applied to tip/tracing/fastboot.

	Ingo
