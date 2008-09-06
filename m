Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYIFRsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYIFRsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYIFRsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:48:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49069 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbYIFRsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:48:42 -0400
Date: Sat, 6 Sep 2008 19:48:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: adjust vmalloc_sync_all() for Xen (2nd try)
Message-ID: <20080906174822.GR4856@elte.hu>
References: <48B7FF69.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B7FF69.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0031]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Since the fourth PDPT entry cannot be shared under Xen,
> vmalloc_sync_all() must iterate over pmd-s rather than pgd-s here.
> Luckily, the code isn't used for native PAE (SHARED_KERNEL_PMD is 1)
> and the change is benign to non-PAE.
> 
> Also do a little more cleanup in that function.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>

applied to tip/x86/xen, thanks Jan.

	Ingo
