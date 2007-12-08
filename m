Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbXLHUMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbXLHUMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXLHUMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:12:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54737 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbXLHUME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:12:04 -0500
Date: Sat, 8 Dec 2007 21:11:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Message-ID: <20071208201137.GA13451@elte.hu>
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com> <alpine.LFD.0.99999.0712080821220.3070@localhost.localdomain> <82e4877d0712080710g205ba93ag12ee204b15d70fdb@mail.gmail.com> <82e4877d0712080736v12c1e31at9149655ae000fe50@mail.gmail.com> <20071208154755.GA5255@elte.hu> <82e4877d0712080800j6572734ek78a76cf7bb17a7e0@mail.gmail.com> <20071208191330.GA21186@elte.hu> <82e4877d0712081133y49fec9bfyee30a3010b37c435@mail.gmail.com> <20071208194211.GA579@elte.hu> <82e4877d0712081208u335c968csd1d3e9259cdd2920@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e4877d0712081208u335c968csd1d3e9259cdd2920@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Parag Warudkar <parag.warudkar@gmail.com> wrote:

> But there are still fluctuations under 100% idle -

do you have CONFIG_HIGH_RES_TIMERS=y?

> IDLE
> real    0m1.112s
> real    0m1.131s
> real    0m1.112s
> real    0m1.112s
> real    0m1.139s

these fluctuations would still be OK if they are due to HZ granularity.

	Ingo
