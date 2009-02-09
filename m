Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbZBIILv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbZBIILv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbZBIILm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:11:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55509 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZBIILl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:11:41 -0500
Date: Mon, 9 Feb 2009 09:11:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: optimize init_kstat_irqs/init_copy_kstat_irqs
Message-ID: <20090209081124.GB24420@elte.hu>
References: <498CB0B7.8030009@kernel.org> <20090206140005.44b4bb50.akpm@linux-foundation.org> <498CB4DC.2010108@kernel.org> <498D3D15.5090005@kernel.org> <20090207002610.73ff7e6d.akpm@linux-foundation.org> <86802c440902070101l5b0ef862ja92e3f31705d9608@mail.gmail.com> <20090207010619.daededa3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090207010619.daededa3.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 7 Feb 2009 01:01:03 -0800 Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > 
> > add kzalloc_node_safe()?
> 
> I cannot find that function.

His suggestion is to provide that allocator variant.

	Ingo
