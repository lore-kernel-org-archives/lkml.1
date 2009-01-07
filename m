Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbZAGNTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbZAGNTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZAGNTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:19:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35795 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZAGNTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:19:12 -0500
Date: Wed, 7 Jan 2009 14:18:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/5] Mark complex bitops.h inlines as __always_inline
Message-ID: <20090107131846.GF3529@elte.hu>
References: <200901051236.281008835@firstfloor.org> <20090104233640.6A7453E6653@basil.firstfloor.org> <Pine.LNX.4.64.0901061847110.29408@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901061847110.29408@blonde.anvils>
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


* Hugh Dickins <hugh@veritas.com> wrote:

> Hugh Dickins noticed that released gcc versions building the kernel with 
> CONFIG_OPTIMIZE_INLINING=y don't inline some of the bitops - sometimes 
> generating very inefficient pageflag tests, and many instances of 
> constant_test_bit().

Could you quantify that please?

We really dont want to reintroduce __always_inline just for performance / 
code size reasons. If GCC messes up and makes a larger / more inefficient 
kernel, GCC will be fixed. CONFIG_OPTIMIZE_INLINING is default-off, so 
enable it only if it improves your kernel.

	Ingo
