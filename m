Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZCNHOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZCNHOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 03:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZCNHOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 03:14:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53197 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZCNHOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 03:14:23 -0400
Date: Sat, 14 Mar 2009 08:14:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: entry_32.S fix compiling warnings
Message-ID: <20090314071415.GB22381@elte.hu>
References: <1237012693.18733.3.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237012693.18733.3.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Hello Ingo,
> 
> Are these looks OK to you:
> 
> Subject: [PATCH] x86: entry_32.S fix compiling warnings
> 
> Fixed:
>  arch/x86/kernel/entry_32.S:446: Warning: 00000000080001d1 shortened to 00000000000001d1
>  arch/x86/kernel/entry_32.S:457: Warning: 000000000800feff shortened to 000000000000feff
>  arch/x86/kernel/entry_32.S:527: Warning: 00000000080001d1 shortened to 00000000000001d1
>  arch/x86/kernel/entry_32.S:541: Warning: 000000000800feff shortened to 000000000000feff
>  arch/x86/kernel/entry_32.S:676: Warning: 0000000008000091 shortened to 0000000000000091

ah, indeed - that's TIF_SYSCALL_FTRACE.

It's in fact faster to check 32 bit mask not a 16 bit mask.

Applied, thanks.

	Ingo
