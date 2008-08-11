Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbYHKVLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbYHKVLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbYHKVLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:11:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34376 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbYHKVLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:11:42 -0400
Date: Mon, 11 Aug 2008 23:11:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tip - oops while running powertop
Message-ID: <20080811211131.GE10774@elte.hu>
References: <82e4877d0808011858v336447dcn9e333407a89c73b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e4877d0808011858v336447dcn9e333407a89c73b@mail.gmail.com>
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


* Parag Warudkar <parag.warudkar@gmail.com> wrote:

> Got the below oops just after running powertop. Does not seem to occur 
> in Linus's tree.

> [  780.776002]  [<c01b126e>] __d_lookup+0x10e/0x120
> [  780.776002]  [<c012aa60>] sched_mc_power_savings_show+0x0/0x20
> [  780.776002]  [<c0216751>] vsnprintf+0x2d1/0x5a0
> [  780.776002]  [<c012aa60>] sched_mc_power_savings_show+0x0/0x20
> [  780.776002]  [<c0119fe1>] flush_tlb_page+0x71/0x80
> [  780.776002]  [<c01b1787>] dput+0x97/0x130

should be fixed in latest tip/master - let me know if it still triggers.

	Ingo
