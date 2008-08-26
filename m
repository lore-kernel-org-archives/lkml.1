Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYHZIOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYHZIOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYHZIOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:14:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46445 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbYHZIOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:14:15 -0400
Date: Tue, 26 Aug 2008 10:13:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: x86: move kstat_irqs from kstat to irq_desc - fix
Message-ID: <20080826081351.GA12150@elte.hu>
References: <1219693279-22803-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219693279-22803-1-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> fix broken with kstat when rebasing sparse_irq
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/irq/sparseirq, thanks Yinghai.

will this fix the powerpc build breakage reported by Stephen?

	Ingo
