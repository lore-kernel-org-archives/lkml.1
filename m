Return-Path: <linux-kernel-owner+w=401wt.eu-S935328AbYBCHNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935328AbYBCHNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 02:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYBCHNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 02:13:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53271 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136AbYBCHND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 02:13:03 -0500
Date: Sun, 3 Feb 2008 08:12:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix compile waring building without CONFIG_SYSCTL
Message-ID: <20080203071251.GB19020@elte.hu>
References: <47A55CA4.9090804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A55CA4.9090804@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> +#ifdef CONFIG_SYSCTL
>  static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
> +#endif

instead of adding another #ifdef, a much cleaner solution would be to 
just reorder do_nmi_callback() with unknown_nmi_panic_callback(), and 
eliminate the prototype altogether.

	Ingo
