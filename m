Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbYLPRjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbYLPRjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYLPRjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:39:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34124 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbYLPRjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:39:08 -0500
Date: Tue, 16 Dec 2008 18:38:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix compiler warning without
	CONFIG_X86_RESERVE_LOW_64K
Message-ID: <20081216173857.GF11683@elte.hu>
References: <4947A0B3.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4947A0B3.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/kernel/setup.c |    2 ++
>  1 file changed, 2 insertions(+)

already fixed in the x86 tree:

bb55746: x86: fix arch/x86/kernel/setup.c build warning when !CONFIG_X86_RESERVE_L

about a month ago.

	Ingo
