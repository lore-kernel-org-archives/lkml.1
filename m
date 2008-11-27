Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYK0ARK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYK0ARK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 19:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYK0AQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 19:16:56 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:38254 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYK0AQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 19:16:55 -0500
Message-ID: <492DE6F4.3060300@ct.jp.nec.com>
Date: Wed, 26 Nov 2008 16:16:52 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: signal: unify signal_{32|64}.c
References: <492B6131.7070902@ct.jp.nec.com> <492B61CB.7030808@ct.jp.nec.com> <20081126041438.GB9732@elte.hu>
In-Reply-To: <20081126041438.GB9732@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Impact: cleanup
>>
>> Add #ifdef directive for 32-bit only code and unify signal_{32|64}.c
>>
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> ---
>>  arch/x86/kernel/Makefile    |    2 +-
>>  arch/x86/kernel/signal.c    |  915 +++++++++++++++++++++++++++++++++++++++++++
>>  arch/x86/kernel/signal_32.c |  909 ------------------------------------------
>>  arch/x86/kernel/signal_64.c |  801 -------------------------------------
>>  4 files changed, 916 insertions(+), 1711 deletions(-)
>>  create mode 100644 arch/x86/kernel/signal.c
>>  delete mode 100644 arch/x86/kernel/signal_32.c
>>  delete mode 100644 arch/x86/kernel/signal_64.c
> 
> yay! :-)
> 
> applied to tip/x86/signal, thanks Hiroshi!
> 
> One small detail, i inserted yet another commit in the middle:
> 
>  5ceb40d: x86: signal: unify signal_{32|64}.c
>  e5fa2d0: x86: signal: unify signal_{32|64}.c, prepare
>  bfeb91a: x86: signal: cosmetic unification of __setup_sigframe() and __setup_rt_sigframe()
>  2601657: x86: signal: move {setup|restore}_sigcontext()
> 
> the e5fa2d0 commit (see it below) contains all the non-mechanic 
> modifications that you did in the final unification commit. It's best 
> to keep this separate - because a big unification commit is hard to 
> review and debug, should it cause any problems.

Hi Ingo,

thanks for the above change, I think I was in a hurry because of
Thanksgiving Day week.

thanks,
Hiroshi Shimamoto
