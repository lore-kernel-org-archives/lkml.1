Return-Path: <linux-kernel-owner+w=401wt.eu-S1758491AbYBAUXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491AbYBAUXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbYBAUXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:23:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714AbYBAUW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:22:59 -0500
Date: Fri, 1 Feb 2008 12:22:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bastian Blank <bastian@waldi.eu.org>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix ext4 bitops
Message-Id: <20080201122257.9524c2bb.akpm@linux-foundation.org>
In-Reply-To: <20080201200208.GA28274@wavehammer.waldi.eu.org>
References: <20080201200208.GA28274@wavehammer.waldi.eu.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008 21:02:08 +0100
Bastian Blank <bastian@waldi.eu.org> wrote:

> Fix ext4 bitops.
> 

This is incomplete.  Please tell us what was "fixed".

If it was a build error then please quote the compile error output in the
changelog, as well as the usual description of what the problem is, and how
it was fixed.

> 
> diff --git a/include/asm-s390/bitops.h b/include/asm-s390/bitops.h
> index dba6fec..47844fc 100644
> --- a/include/asm-s390/bitops.h
> +++ b/include/asm-s390/bitops.h
> @@ -762,6 +762,8 @@ static inline int sched_find_first_bit(unsigned long *b)
>   *    23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
>   */
>  
> +#include <asm-generic/bitops/le.h>
> +
>  #define ext2_set_bit(nr, addr)       \
>  	__test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
>  #define ext2_set_bit_atomic(lock, nr, addr)       \


