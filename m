Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbZA2J6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbZA2J6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 04:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZA2J6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 04:58:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:47612 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbZA2J6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 04:58:41 -0500
Subject: Re: [patch-rt 4/4] sched: mark SCHED_HRTICK broken
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Carsten Emde <carsten.emde@osadl.org>
In-Reply-To: <20090128212709.371517363@linutronix.de>
References: <20090128211912.300823284@linutronix.de>
	 <20090128212709.371517363@linutronix.de>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 10:58:28 +0100
Message-Id: <1233223108.4495.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 21:29 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (do-not-configure-sched-hrtick-since-it-is-currently-broken.patch)
> SCHED_HRTICK is broken and not yet fixed in mainline. WTF is it still
> enabled in -rt ?

It got fixed in mainline, but past .26. That said, we still disabled in
in mainline because of performance issues.

> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Tested-by: Carsten Emde <C.Emde@osadl.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/Kconfig.hz |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.26/kernel/Kconfig.hz
> ===================================================================
> --- linux-2.6.26.orig/kernel/Kconfig.hz
> +++ linux-2.6.26/kernel/Kconfig.hz
> @@ -55,4 +55,4 @@ config HZ
>  	default 1000 if HZ_1000
>  
>  config SCHED_HRTICK
> -	def_bool HIGH_RES_TIMERS && X86
> +	def_bool HIGH_RES_TIMERS && X86 && BROKEN
> 

