Return-Path: <linux-kernel-owner+w=401wt.eu-S935220AbYD1PYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935220AbYD1PYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933820AbYD1PYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:24:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43305 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933261AbYD1PYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:24:34 -0400
Date: Mon, 28 Apr 2008 17:24:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: vget_cycles() __always_inline
Message-ID: <20080428152422.GD18776@elte.hu>
References: <Pine.LNX.4.64.0804270035200.30877@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804270035200.30877@blonde.site>
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


* Hugh Dickins <hugh@veritas.com> wrote:

> Mark vget_cycles() as __always_inline, so gcc is never tempted to make 
> the vsyscall vread_tsc() dive into kernel text, with resulting 
> SIGSEGV.
> 
> This was a self-inflicted wound: I've not seen that happen with 
> unhacked sources; but for debug reasons I'd changed my x86/Makefile to 
> compile no-unit-at-a-time, and that in conjunction with 
> OPTIMIZE_INLINING=y ended up with vget_cycles() in kernel text.  
> Perhaps it can happen in other ways: safer to use __always_inline.

applied, thanks Hugh - i agree that this is worth fixing.

	Ingo
