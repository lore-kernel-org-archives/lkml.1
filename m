Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYLPRlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYLPRlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYLPRlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:41:02 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38795 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbYLPRlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:41:00 -0500
Date: Tue, 16 Dec 2008 18:40:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] allow bug table entries to use relative pointers (and
	use it on x86-64)
Message-ID: <20081216174048.GH11683@elte.hu>
References: <4947A1BB.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4947A1BB.76E4.0078.0@novell.com>
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

> This allows reducing the bug table size by half. Perhaps there are
> other 64-bit architectures that could also make use of this.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/Kconfig           |    4 ++++
>  arch/x86/include/asm/bug.h |    2 +-
>  include/asm-generic/bug.h  |    8 ++++++++
>  lib/bug.c                  |   19 +++++++++++++++++--
>  4 files changed, 30 insertions(+), 3 deletions(-)

applied to tip/x86/debug, thanks Jan!

	Ingo
