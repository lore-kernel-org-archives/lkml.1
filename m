Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbYLJLqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbYLJLqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 06:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYLJLqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 06:46:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62441 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYLJLqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 06:46:32 -0500
Date: Wed, 10 Dec 2008 06:46:30 -0500 (EST)
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
Subject: Re: [PATCH][RT] Compile-time fix.
In-Reply-To: <1228892002.9542.4.camel@dd>
Message-ID: <alpine.DEB.1.10.0812100643130.5912@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812090946210.16798@gandalf.stny.rr.com>  <1228890920.9542.2.camel@dd> <1228892002.9542.4.camel@dd>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Dec 2008, Sven-Thorsten Dietrich wrote:

> 
> Compile-time fix.
> 
> Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
> 
> diff --git a/include/linux/mutex.h b/include/linux/mutex.h
> index 585feed..b74fdc2 100644
> --- a/include/linux/mutex.h
> +++ b/include/linux/mutex.h
> @@ -14,7 +14,7 @@
>  #include <linux/spinlock_types.h>
>  #include <linux/linkage.h>
>  #include <linux/lockdep.h>
> -
> +#include <linux/spinlock.h>
>  #include <asm/atomic.h>
>  
>  /*

Sven,

Thanks for looking into this, but do not get too eager to send updates 
yet. I'm massively rewriting the rt/rt-locks branch, and the flux rate is 
very high. A patch like this will become obsolete in seconds.

If you do want to help, look at any of the other branches. Some have not 
been updated yet, and they all should be able to compile and boot on their 
own. If they do not, then those need to be fixed.

Thanks,

-- Steve

