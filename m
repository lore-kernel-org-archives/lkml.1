Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbZDPJLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbZDPJLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZDPJLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:11:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45157 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbZDPJLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:11:12 -0400
Date: Thu, 16 Apr 2009 11:10:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] irq: change irq_desc_alloc to take node instead cpu
Message-ID: <20090416091008.GH9813@elte.hu>
References: <49E68C41.4020801@kernel.org> <49E68D0D.30606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E68D0D.30606@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: prepare to make irq_desc_alloc to numa aware
> 
> so could make irq_desc_alloc use node pass down

Yes - this static approach will work far better than dynamically 
migrating IRQ descriptors. IRQ migration is ... fragile, both in 
hardware, and in terms of sw complexity.

	Ingo
