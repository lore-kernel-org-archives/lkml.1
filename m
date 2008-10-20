Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbYJTQ2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbYJTQ2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYJTQ2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:28:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbYJTQ2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:28:01 -0400
Date: Mon, 20 Oct 2008 18:27:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] ftrace : Fix section mismatch warning.
Message-ID: <20081020162756.GA31201@elte.hu>
References: <b9df5fa10810122250j1dd9c0eaq8c708c7b8e10a249@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10810122250j1dd9c0eaq8c708c7b8e10a249@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> WARNING: arch/x86/kernel/built-in.o(.text+0x11b41): Section mismatch
> in reference from the variable ftrace_test_p6nop to the function
> .init.text:ftrace_dyn_arch_init()
> The function ftrace_test_p6nop() references
> the function __init ftrace_dyn_arch_init().
> This is often because ftrace_test_p6nop lacks a __init
> annotation or the annotation of ftrace_dyn_arch_init is wrong.
> 
> WARNING: arch/x86/kernel/built-in.o(.text+0x11b4b): Section mismatch
> in reference from the variable ftrace_test_nop5 to the function
> .init.text:ftrace_dyn_arch_init()
> The function ftrace_test_nop5() references
> the function __init ftrace_dyn_arch_init().
> This is often because ftrace_test_nop5 lacks a __init
> annotation or the annotation of ftrace_dyn_arch_init is wrong.
> 
> This patch fixes the above warnings. Introduced by
> 'linux-next.patch'(2.6.27-rc5-mm1-broken-out).
> Thanks.
> 
> Signed-off-by: Md.Rakib H. Mullick(rakib.mullick@gmail.com)

applied to tip/tracing/urgent, thanks!

	Ingo
