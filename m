Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbYKWS5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbYKWS5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYKWS5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:57:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48747 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757886AbYKWS5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:57:39 -0500
Date: Sun, 23 Nov 2008 19:57:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE_ENTRY)_X86  assembly
	helpers to catch unbalanced declaration v3
Message-ID: <20081123185726.GB21106@elte.hu>
References: <20081123172139.GC12710@localhost> <20081123173015.GE12710@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123173015.GE12710@localhost>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> | Impact: improvements
> | 
> | It's usefull to catch unbalanced or messed or mixed declarations of ENTRY and
> | KPROBES. These macros would help a bit.

applied to tip/x86/irq, thanks Cyrill.

Now lets try a patch that makes use of it in the entry*.S files, and 
see the fallout?

	Ingo
