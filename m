Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbYKFHDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbYKFHDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYKFHDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:03:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51115 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbYKFHDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:03:03 -0500
Date: Thu, 6 Nov 2008 08:02:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: signal_32: do save_i387_xstate() at
	get_sigframe()
Message-ID: <20081106070248.GF15731@elte.hu>
References: <491256C1.2060709@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491256C1.2060709@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2548]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i've applied your patches to tip/x86/signal:

 8735b7d: x86: signal_64: make setup_sigcontext() similar
 ee7d523: x86: signal_64: setup fpstate in setup_sigcontext()
 99ea1b9: x86: ia32_signal: do save_i387_xstate_ia32 at get_sigframe()
 4b33669: x86: signal_32: do save_i387_xstate() at get_sigframe()

thanks!

	Ingo
