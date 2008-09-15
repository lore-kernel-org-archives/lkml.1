Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYIOMwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYIOMwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 08:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYIOMwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 08:52:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35456 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbYIOMwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 08:52:08 -0400
Date: Mon, 15 Sep 2008 14:51:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86-64: fix combining of regions in
	init_memory_mapping()
Message-ID: <20080915125150.GC304@elte.hu>
References: <48CA9C18.76E4.0078.0@novell.com> <86802c440809141120v5f468775n81de6a29bbb89019@mail.gmail.com> <48CE3633.76E4.0078.0@novell.com> <86802c440809150134w3cd3f5baq2e99d2bb61b31a16@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809150134w3cd3f5baq2e99d2bb61b31a16@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > The issue is apparently pretty benign to native code, but surfaces 
> > as a boot time crash in our forward ported Xen tree (where the page 
> > table setup overall works differently than in native). Since the 
> > underlying issue was present in native (and since I assume if there 
> > is an attempt to merge subsequent regions, then it should work 
> > right), I nevertheless submitted the patch for native inclusion.
> 
> yes. your patch fixed the skip...
> 
> Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/x86/core, thanks!

	Ingo
