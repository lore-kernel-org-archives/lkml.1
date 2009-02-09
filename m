Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZBIIq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZBIIq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbZBIIqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:46:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35375 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZBIIqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:46:20 -0500
Date: Mon, 9 Feb 2009 09:46:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: Don't pretend that non-framepointer stack traces
	are reliable
Message-ID: <20090209084603.GA20270@elte.hu>
References: <20090207122337.4c0f25b7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090207122337.4c0f25b7@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> >From f460ce92e09770691855b98a904556e92d39ead9 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sat, 7 Feb 2009 12:20:20 -0800
> Subject: [PATCH] x86: Don't pretend that non-framepointer stack traces are reliable
> 
> without frame pointers enabled, the x86 stack traces should not
> pretend to be reliable; instead they should just be what they are:
> unreliable.
> 
> The effect of this is that they have a ? printed in the stacktrace,
> to warn the reader that these entries are guesses rather than known
> based on more reliable information.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  arch/x86/kernel/dumpstack.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip/x86/debug, thanks Arjan!

	Ingo
