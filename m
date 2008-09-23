Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYIWOeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYIWOeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYIWOd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:33:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38594 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYIWOd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:33:59 -0400
Date: Tue, 23 Sep 2008 16:33:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] - Fix ordering of calls to uv_system_init & uv_cpu_init
Message-ID: <20080923143346.GE14041@elte.hu>
References: <20080923134205.GA26688@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923134205.GA26688@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> Fix problem caused by reordering of the calls to uv_cpu_init() &
> uv_system_init. Originally, uv_cpu_init() was called AFTER uv_system_init.
> This order was recently broken as a side-effect of other patches.
> 
> With this patch, initialization of cpu 0 is now done by the system_init
> call.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>

applied to tip/irq/sparseirq (where this bug originates from), thanks 
Jack!

	Ingo
