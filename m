Return-Path: <linux-kernel-owner+w=401wt.eu-S1762911AbXHHWVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762911AbXHHWVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXHHWVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:21:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35942 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbXHHWVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:21:08 -0400
Date: Thu, 9 Aug 2007 00:19:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: kvm warning
Message-ID: <20070808221956.GA16238@elte.hu>
References: <20070808151446.9a4eebda.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808151446.9a4eebda.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4386]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> ia64 allmodconfig says
> 
> drivers/kvm/Kconfig:14:warning: 'select' used by config symbol 'KVM' 
> refers to undefined symbol 'PREEMPT_NOTIFIERS'

hm, why doesnt ia64 pick up kernel/Kconfig.preempt, like all the other 
arches? Due to that ia64 also misses out on voluntary preempt and on 
preempt-bkl.

	Ingo
