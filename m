Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbZGBHJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbZGBHJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 03:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbZGBHJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 03:09:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59749 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbZGBHJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 03:09:23 -0400
Date: Thu, 2 Jul 2009 09:09:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v4] x86: Fix printk call in print_local_apic()
Message-ID: <20090702070909.GA4690@elte.hu>
References: <4A4C3410.8080704@kernel.org> <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain> <alpine.LFD.2.01.0907012126371.3380@localhost.localdomain> <4A4C43BC.90506@kernel.org> <20090702061254.GA23277@elte.hu> <20090702062847.GB23277@elte.hu> <20090701234848.03dfa601.akpm@linux-foundation.org> <20090702065922.GB28135@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702065922.GB28135@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


this is how it gets printed here with apic-debug enabled:

[    6.519850] ... APIC ISR field:
[    6.523249] 0000000000000000000000000000000000000000000000000000000000000000
[    6.531085] ... APIC TMR field:
[    6.534484] 0000000000000000000000000000000000000000000000000000000000000000
[    6.542322] ... APIC IRR field:
[    6.545721] 0000000000000000000000000000000000000000000000000000000000008000

That's plenty enough.

	Ingo
