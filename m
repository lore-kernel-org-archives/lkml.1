Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYGRLxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYGRLxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbYGRLxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:53:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56533 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbYGRLxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:53:30 -0400
Date: Fri, 18 Jul 2008 13:53:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: ia32_signal.c: use macro instead of immediate
Message-ID: <20080718115313.GH6875@elte.hu>
References: <487BC1B9.1090400@ct.jp.nec.com> <487BCD9C.4030003@zytor.com> <487BD10F.2060408@ct.jp.nec.com> <487BD1DD.9040008@zytor.com> <487BD461.30903@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487BD461.30903@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0396]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Make and use macro FIX_EFLAGS, instead of immediate value 0x40DD5 in
> ia32_restore_sigcontext().

applied to tip/x86/cleanups - thanks!

	Ingo
