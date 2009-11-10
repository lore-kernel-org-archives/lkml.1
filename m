Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbZKJJk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbZKJJk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZKJJk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:40:57 -0500
Received: from atlanta.zankel.net ([69.61.78.146]:4959 "EHLO
	atlanta.zankel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbZKJJk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:40:57 -0500
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2009 04:40:57 EST
Message-ID: <4AF9338E.6050103@zankel.net>
Date: Tue, 10 Nov 2009 01:34:06 -0800
From: Chris Zankel <chris@zankel.net>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 15/16] xtensa: Replace old style lock initializer
References: <20091106223547.784916750@linutronix.de> <20091106223807.013213923@linutronix.de>
In-Reply-To: <20091106223807.013213923@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> SPIN_LOCK_UNLOCKED is deprecated. Use __SPIN_LOCK_UNLOCKED instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Zankel <chris@zankel.net>
> ---
>  arch/xtensa/include/asm/rwsem.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/xtensa/include/asm/rwsem.h
> ===================================================================
> --- linux-2.6.orig/arch/xtensa/include/asm/rwsem.h
> +++ linux-2.6/arch/xtensa/include/asm/rwsem.h
> @@ -38,7 +38,7 @@ struct rw_semaphore {
>  };
>  
>  #define __RWSEM_INITIALIZER(name) \
> -	{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
> +	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
>  	  LIST_HEAD_INIT((name).wait_list) }
>  
>  #define DECLARE_RWSEM(name)		\
> 

