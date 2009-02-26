Return-Path: <linux-kernel-owner+w=401wt.eu-S1760556AbZBZFk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556AbZBZFk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZBZFkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:40:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49441 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbZBZFkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:40:46 -0500
Date: Thu, 26 Feb 2009 06:40:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
Message-ID: <20090226054023.GA30543@elte.hu>
References: <49A626B2.8090205@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A626B2.8090205@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: cleanup
> 
> that is only needed when CONFIG_X86_VSMP is defined with 64bit
> also remove dead code about PCI, because CONFIG_X86_VSMP depends on PCI
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/apic.h  |    7 +++++++
>  arch/x86/include/asm/setup.h |    4 ++++
>  arch/x86/kernel/Makefile     |    2 +-
>  arch/x86/kernel/setup.c      |    2 --
>  arch/x86/kernel/vsmp_64.c    |   12 +-----------
>  5 files changed, 13 insertions(+), 14 deletions(-)

Applied to tip:x86/apic, thanks Yinghai!

	Ingo
