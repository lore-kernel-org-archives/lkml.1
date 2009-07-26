Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZGZXEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZGZXEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZGZXEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:04:45 -0400
Received: from fifo99.com ([67.223.236.141]:50469 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbZGZXEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:04:45 -0400
Subject: Re: [Patch RFC 01/37] semaphore: Add DEFINE_SEMAPHORE,
 semaphore_init, semaphore_init_locked
From: Daniel Walker <dwalker@fifo99.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20090726081553.328151390@linutronix.de>
References: <20090726081459.455111897@linutronix.de>
	 <20090726081553.328151390@linutronix.de>
Content-Type: text/plain
Date: Sun, 26 Jul 2009 16:04:49 -0700
Message-Id: <1248649489.28841.11.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-26 at 08:17 +0000, Thomas Gleixner wrote:

> +static inline void __deprecated semaphore_init_locked(struct semanphore *sem)
> +{
> +	sema_init(sem, 0);
> +}
> +
>  #define init_MUTEX(sem)		sema_init(sem, 1)
>  #define init_MUTEX_LOCKED(sem)	sema_init(sem, 0)

Maybe you could introduce this _after_ you do the semaphore to
completion cleanup .. This init_locked is just adding a bunch of code
flux on top of that..

Daniel

