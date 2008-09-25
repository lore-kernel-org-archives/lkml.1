Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbYIYIhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbYIYIhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYIYIhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:37:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41216 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbYIYIhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:37:03 -0400
Date: Thu, 25 Sep 2008 10:36:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 5/7] x86: fix typo in irq_desc array
Message-ID: <20080925083643.GC4519@elte.hu>
References: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com> <1222308277-10984-5-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222308277-10984-5-git-send-email-yhlu.kernel@gmail.com>
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

> when SPARSE_IRQ is not used, should still use irq_desc->lock
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> ---
>  kernel/irq/handle.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip/irq/sparseirq, thanks Yinghai!

	Ingo
