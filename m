Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbYLJLmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbYLJLmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 06:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYLJLmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 06:42:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37452 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbYLJLmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 06:42:23 -0500
Date: Wed, 10 Dec 2008 06:42:19 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Gregory Haskins <ghaskins@novell.com>, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH][RT] lock.h: fix spelling of contended
In-Reply-To: <1228890920.9542.2.camel@dd>
Message-ID: <alpine.DEB.1.10.0812100642010.5912@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812090946210.16798@gandalf.stny.rr.com> <1228890920.9542.2.camel@dd>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Dec 2008, Sven-Thorsten Dietrich wrote:

> Maybe it'll save you a half second...
> 
> Signed-off-by: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
> 
> diff --git a/include/linux/lock.h b/include/linux/lock.h
> index e0d10d6..785bf7d 100644
> --- a/include/linux/lock.h
> +++ b/include/linux/lock.h
> @@ -11,7 +11,7 @@
>  #define DEFINE_LOCK(l)				DEFINE_SPINLOCK(l)
>  #define lock_init(l)				spin_lock_init(l)
>  #define lock_is_locked(l)			spin_is_locked(l)
> -#define lock_is_contended(l)			spin_is_conteted(l)
> +#define lock_is_contended(l)			spin_is_contended(l)
>  #define lock_can_lock(l)			spin_can_lock(l)
>  #define assert_lock_locked(l)			assert_spin_locked(l)

Thanks, I already fixed it though ;-)

-- Steve

