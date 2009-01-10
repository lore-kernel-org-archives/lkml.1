Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZAJW6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZAJW6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbZAJW6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:58:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58802 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbZAJW6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:58:13 -0500
Date: Sat, 10 Jan 2009 23:57:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: x86 maintainers <x86@kernel.org>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PULL -tip] x86: smp.h move cpumask related things to cpumask.h
Message-ID: <20090110225759.GG17917@elte.hu>
References: <3f9a31f40901100102q79a24dcbiaeaf4bf97d7c02a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901100102q79a24dcbiaeaf4bf97d7c02a3@mail.gmail.com>
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> The following changes since commit 22e34e5f3362464f1095bc028fc5df945663cd0a:
>   Ingo Molnar (1):
>         manual merge of out-of-tree
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git
> master
> 
> Jaswinder Singh Rajput (4):
>       x86: smp.h move cpu_callin_mask and cpu_callin_map declartion to cpumask.h
>       x86: smp.h move cpu_callout_mask and cpu_callout_map declartion
> to cpumask.h
>       x86: smp.h move cpu_initialized_mask and cpu_initialized
> declartion to cpumask.h
>       x86: smp.h move cpu_sibling_setup_mask and cpu_sibling_setup_map
> declartion to cpumask.h
> 
>  arch/x86/include/asm/cpumask.h |   28 ++++++++++++++++++++++++++++
>  arch/x86/include/asm/smp.h     |   22 +---------------------
>  arch/x86/kernel/cpu/common.c   |    1 +
>  arch/x86/kernel/setup_percpu.c |    1 +
>  4 files changed, 31 insertions(+), 21 deletions(-)
>  create mode 100644 arch/x86/include/asm/cpumask.h

Pulled into tip/x86/cleanups, thanks Jaswinder!

	Ingo
