Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYIFRau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYIFRau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYIFRak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:30:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51673 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbYIFRaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:30:39 -0400
Date: Sat, 6 Sep 2008 19:29:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dyn_array: remove one panic
Message-ID: <20080906172950.GN4856@elte.hu>
References: <1220722010-12302-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220722010-12302-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Andrew said, we don't need duplicated panic.
> because __alloc_bootmem already have that.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/irq/sparseirq, thanks.

Maybe some design documentation would be nice too, to point out that 
most of the pain we do here is because we dont have bootmem available as 
early as we need an already instantiated dyn-array based IRQ array.

So we try this mix of an abstraction of preallocated and post-allocated 
array, with pre-bootmem and post-bootmem behavior.

	Ingo
