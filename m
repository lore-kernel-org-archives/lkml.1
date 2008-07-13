Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbYGMJ2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbYGMJ2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 05:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYGMJ2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 05:28:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54648 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbYGMJ2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 05:28:38 -0400
Date: Sun, 13 Jul 2008 11:28:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make 64bit have get_apic_id
Message-ID: <20080713092823.GA21306@elte.hu>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807111843.11157.yhlu.kernel@gmail.com> <200807111844.17084.yhlu.kernel@gmail.com> <200807120101.20554.yhlu.kernel@gmail.com> <20080713062802.GC2534@elte.hu> <20080713065917.GA29634@elte.hu> <86802c440807130005x721b781dy6d4b569f4c736a22@mail.gmail.com> <20080713092324.GA12749@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080713092324.GA12749@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > > Yinghai, you had that x86/x2apic crash - do you think we can now 
> > > try it again in tip/master?
> > 
> > Yes. it looks good now. I test it for two days already. no problem 
> > found.
> 
> ok, thanks - i've merged it into tip/master and will do some more 
> testing myself as well.

the paravirt build is still broken:

 arch/x86/kernel/paravirt.c:377: error: expected identifier before ‘(' token
 arch/x86/kernel/paravirt.c:378: error: expected ‘}' before ‘.' token

with:

  http://redhat.com/~mingo/misc/config-Sun_Jul_13_11_25_20_CEST_2008.bad

	Ingo
