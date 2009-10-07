Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbZJGNwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbZJGNwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbZJGNwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:52:17 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45427 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759125AbZJGNwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:52:16 -0400
Message-ID: <4ACC9CE6.7000908@us.ibm.com>
Date: Wed, 07 Oct 2009 06:51:34 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: tgxl@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: Fix typo in FUTEX_WAIT_BITSET_PRIVATE and FUTEX_WAKE_BITSET_PRIVATE
 definitions
References: <20091007001358.GE16073@kryten>
In-Reply-To: <20091007001358.GE16073@kryten>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard wrote:
> Looks like a typo, FUTEX_WAKE_BITS should be FUTEX_WAIT_BITSET.
> 

It certainly does...

> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Darren Hart <dvhltc@us.ibm.com>


> ---
> 
> Index: linux.trees.git/include/linux/futex.h
> ===================================================================
> --- linux.trees.git.orig/include/linux/futex.h	2009-10-02 16:53:02.000000000 +1000
> +++ linux.trees.git/include/linux/futex.h	2009-10-02 16:53:42.000000000 +1000
> @@ -33,8 +33,8 @@
>  #define FUTEX_LOCK_PI_PRIVATE	(FUTEX_LOCK_PI | FUTEX_PRIVATE_FLAG)
>  #define FUTEX_UNLOCK_PI_PRIVATE	(FUTEX_UNLOCK_PI | FUTEX_PRIVATE_FLAG)
>  #define FUTEX_TRYLOCK_PI_PRIVATE (FUTEX_TRYLOCK_PI | FUTEX_PRIVATE_FLAG)
> -#define FUTEX_WAIT_BITSET_PRIVATE	(FUTEX_WAIT_BITS | FUTEX_PRIVATE_FLAG)
> -#define FUTEX_WAKE_BITSET_PRIVATE	(FUTEX_WAKE_BITS | FUTEX_PRIVATE_FLAG)
> +#define FUTEX_WAIT_BITSET_PRIVATE	(FUTEX_WAIT_BITSET | FUTEX_PRIVATE_FLAG)
> +#define FUTEX_WAKE_BITSET_PRIVATE	(FUTEX_WAKE_BITSET | FUTEX_PRIVATE_FLAG)
>  #define FUTEX_WAIT_REQUEUE_PI_PRIVATE	(FUTEX_WAIT_REQUEUE_PI | \
>  					 FUTEX_PRIVATE_FLAG)
>  #define FUTEX_CMP_REQUEUE_PI_PRIVATE	(FUTEX_CMP_REQUEUE_PI | \


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
