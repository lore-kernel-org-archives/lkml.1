Return-Path: <linux-kernel-owner+w=401wt.eu-S1762867AbYESPtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762867AbYESPtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759641AbYESPrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:47:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38096 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760998AbYESPrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:47:20 -0400
Date: Mon, 19 May 2008 17:46:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: update mptable v3
Message-ID: <20080519154658.GA11375@elte.hu>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200805061038.58023.yhlu.kernel@gmail.com> <200805070048.46957.yhlu.kernel@gmail.com> <200805161932.05732.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805161932.05732.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> make mptable to be consistent to acpi routing, so we could
> 1. kexec kernel with acpi=off
> 2. workaround BIOS that acpi routing is working, but mptable is not right.
>    so can use kernel/kexec to start other os that doesn't have good acpi support
> 
> command line: update_mptable
> 
> v2: add alloc_mptable for mptable that can not be changed.
>     new command line: alloc_mptable
> v3: adjust for patch that move some mp_xxx to acpi..., and mpc_ to mp_

-tip testing found a build failure with this patch:

 arch/x86/kernel/mpparse.c: In function 'get_MP_intsrc_index':
 arch/x86/kernel/mpparse.c:891: error: 'mp_irq_entries' undeclared (first use inthis function)
 arch/x86/kernel/mpparse.c:891: error: (Each undeclared identifier is reported only once
 [...]

config at:

 http://redhat.com/~mingo/misc/config-Mon_May_19_17_38_13_CEST_2008.bad

	Ingo
