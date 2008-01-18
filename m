Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYARINZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYARINZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbYARINS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:13:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49383 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbYARINR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:13:17 -0500
Date: Fri, 18 Jan 2008 09:13:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_32: remove the useless NR_syscalls macro
Message-ID: <20080118081306.GC16597@elte.hu>
References: <47901FE9.9020403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47901FE9.9020403@gmail.com>
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


* Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:

> This is against current x86.git.
> 
> The size of the system call table for 32-bit x86 kernels is obtained 
> by compile-time calculation of the sys_call_table array, not from the 
> value, which the NR_syscalls macro expands to. This trivial patch 
> removes the fossil macro.
> 
> Manually tested by grepping the x86 files for the "NR_syscalls" 
> string. No relevant use cases found.
> 
> Build-tested using allyesconfig, allnoconfig and a couple of 
> randconfig instances. All builds successfully finished.
> 
> Runtime test performed using a stripped-down Debian-ish config. The 
> system booted successfully.

thanks, applied.

	Ingo
