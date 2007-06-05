Return-Path: <linux-kernel-owner+w=401wt.eu-S1764023AbXFEJSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764023AbXFEJSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762918AbXFEJSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:18:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41545 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761905AbXFEJSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:18:35 -0400
Date: Tue, 5 Jun 2007 11:18:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1
Message-ID: <20070605091829.GA19302@elte.hu>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070605091151.GA18385@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605091151.GA18385@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> the NMI watchdog warning is a bit weird:
> 
>  Calling initcall 0xc0613e4f: check_nmi_watchdog+0x0/0x1a8()
>  Testing NMI watchdog ... CPU#0: NMI appears to be stuck (0->0)!
>  CPU#1: NMI appears to be stuck (0->0)!
>  initcall 0xc0613e4f: check_nmi_watchdog+0x0/0x1a8() returned -1.
>  initcall 0xc0613e4f ran for 27 msecs: check_nmi_watchdog+0x0/0x1a8()
> 
> i'll test it in a minute with that turned off.

yeah, with nmi_watchdog=0 it works fine. nmi_watchdog=2 always worked on 
this box so this is some new regression.

	Ingo
