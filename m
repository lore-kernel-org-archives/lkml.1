Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYIEOsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYIEOsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYIEOr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:47:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbYIEOr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:47:58 -0400
Date: Fri, 5 Sep 2008 16:47:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dean Nelson <dcn@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] set_irq_chip() has redundant call to irq_to_desc()
Message-ID: <20080905144736.GB10292@elte.hu>
References: <20080905141040.GB9393@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905141040.GB9393@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dean Nelson <dcn@sgi.com> wrote:

> Extraneous call to irq_to_desc().
> 
> Signed-off-by: Dean Nelson <dcn@sgi.com>

applied to tip/irq/sparseirq, thanks.

	Ingo
