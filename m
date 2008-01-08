Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbYAHHIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbYAHHIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 02:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYAHHIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 02:08:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46661 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbYAHHIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 02:08:15 -0500
Date: Tue, 8 Jan 2008 08:07:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch 1/2] Turn 64 bit x86 HANDLE_STACK into
	print_context_stack like 32 bit has
Message-ID: <20080108070756.GA31838@elte.hu>
References: <20080107211343.18b48da8@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107211343.18b48da8@laptopd505.fenrus.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> Subject: Turn 64 bit x86 HANDLE_STACK into print_context_stack like 32 bit has
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> This patch turns the x86 64 bit HANDLE_STACK macro in the backtrace 
> code into a function, just like 32 bit has. This is needed pre work in 
> order to get exact backtraces for CONFIG_FRAME_POINTER to work.
> 
> The function and it's arguments are not the same as 32 bit; due to the 
> exception/interrupt stack way of x86-64 there are a few differences.
> 
> This patch should not have any behavior changes, only code movement.
> 
> Due to the fragility and importance of the backtrace code, this needs 
> to be well reviewed and well tested before merging into mainlne.

thanks, applied.

	Ingo
