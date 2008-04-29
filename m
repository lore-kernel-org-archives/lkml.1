Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbYD2WK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbYD2WK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYD2WKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:10:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59259 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbYD2WKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:10:11 -0400
Date: Wed, 30 Apr 2008 00:09:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mika Fischer <mika.fischer@zoopnet.de>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to
	discrete layout v5
Message-ID: <20080429220953.GI2302@elte.hu>
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804281244.56938.yhlu.kernel@gmail.com> <200804281316.14168.yhlu.kernel@gmail.com> <200804281505.05764.yhlu.kernel@gmail.com> <m1wsmg32qk.fsf@frodo.ebiederm.org> <86802c440804291304r7ff169f6k9132f98761ecef42@mail.gmail.com> <m1abjcz9ow.fsf@frodo.ebiederm.org> <86802c440804291457k79099d84w53110fabf59e9e37@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804291457k79099d84w53110fabf59e9e37@mail.gmail.com>
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

> agreed. so that feature is compiled in but disable by default.
> 
> BTW: is any chance for OS to disable SMI etc? to verify is the 
> unstatbility is caused by SMI?

i dont think there's any documented way for that. SMI might be the 
mechanism that ensures blue-smoke type of system reliability (CPU fan, 
temperature, etc.) so it would be extremely dangerous to mess with it.

	Ingo
