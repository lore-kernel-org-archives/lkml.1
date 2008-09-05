Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYIEOrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYIEOrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYIEOrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:47:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59726 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbYIEOrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:47:08 -0400
Date: Fri, 5 Sep 2008 16:46:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dean Nelson <dcn@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] error missed ifndef CONFIG_HAVE_SPARSE_IRQ
Message-ID: <20080905144648.GA10292@elte.hu>
References: <20080905140720.GA9393@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905140720.GA9393@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1116]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dean Nelson <dcn@sgi.com> wrote:

> An error return from create_irq_nr() is 0, but an error return from
> create_irq() is -1.
> 
> Signed-off-by: Dean Nelson <dcn@sgi.com>

applied to tip/irq/sparseirq - thanks Dean!

	Ingo
