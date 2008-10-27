Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbYJ0JxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbYJ0JxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYJ0JxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:53:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52655 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbYJ0JxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:53:10 -0400
Date: Mon, 27 Oct 2008 10:52:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: trace: fix printk warning for u64
Message-ID: <20081027095248.GA6969@elte.hu>
References: <20081027174328.084649ab.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027174328.084649ab.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> A powerpc ppc64_defconfig build produces these warnings:
> 
> kernel/trace/ring_buffer.c: In function 'rb_add_time_stamp':
> kernel/trace/ring_buffer.c:969: warning: format '%llu' expects type 'long long unsigned int', but argument 2 has type 'u64'
> kernel/trace/ring_buffer.c:969: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'u64'
> kernel/trace/ring_buffer.c:969: warning: format '%llu' expects type 'long long unsigned int', but argument 4 has type 'u64'
> 
> Just cast the u64s to unsigned long long like we do everywhere else.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

applied to tip/tracing/urgent, thanks Stephen!

(btw., did the "unify u64 definitions across all platforms" project 
get anywhere?)

	Ingo
