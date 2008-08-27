Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbYH0ICR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbYH0ICR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 04:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYH0IB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 04:01:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37479 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbYH0IB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 04:01:57 -0400
Date: Wed, 27 Aug 2008 10:01:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] exit signals: use of uninitialized field notify_count
Message-ID: <20080827080136.GA4453@elte.hu>
References: <alpine.DEB.1.00.0808261505550.15543@abydos.NerdBox.Net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0808261505550.15543@abydos.NerdBox.Net>
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


* Steve VanDeBogart <vandebo-lkml@NerdBox.Net> wrote:

> task->signal->notify_count is only initialized if
> task->signal->group_exit_task is not NULL.  Reorder a conditional so
> that uninitialised memory is not used.  Found by Valgrind.
>
> Signed-off-by: Steve VanDeBogart <vandebo-lkml@nerdbox.net>

Applied the commit below to tip/core/urgent, thanks. Roland/Oleg, do you 
concur with the fix?

nice find btw. - are you running Valgrind on UML?

	Ingo
