Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYD2Keh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYD2Keh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbYD2Ke2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:34:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37221 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbYD2Ke2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:34:28 -0400
Date: Tue, 29 Apr 2008 12:34:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, balajirrao@gmail.com,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Message-ID: <20080429103409.GK23198@elte.hu>
References: <4815DE0C.6000802@googlemail.com> <86802c440804281206u6b5086a3h42192b7d36b08325@mail.gmail.com> <481627B7.9060406@googlemail.com> <4816376B.8060907@googlemail.com> <48163F56.70704@googlemail.com> <86802c440804281503q1f9e6f8anb18cd514e89b76fe@mail.gmail.com> <4816562B.2070905@googlemail.com> <86802c440804281623m28a5cf5x701580d0f007c097@mail.gmail.com> <48167473.80207@googlemail.com> <86802c440804281941h440c7a86kd86fd4d9dcf91ad4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804281941h440c7a86kd86fd4d9dcf91ad4@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> v2: fix -1 for UC checking
> v3: default to disable, and need use enable_mtrr_cleanup to enable this feature
>     skip the var state change warning.
>     remove next_basek in range_to_mtrr()
> v4: correct warning mask.
> v5: CONFIG_MTRR_SANITIZER
> v6: 1g, 2g, 512 aligment with extra hole

thanks Yinghai, i picked up v6.

	Ingo
