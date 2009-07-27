Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZG0Q3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZG0Q3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbZG0Q3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:29:10 -0400
Received: from www.tglx.de ([62.245.132.106]:33401 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbZG0Q3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:29:08 -0400
Date: Mon, 27 Jul 2009 18:28:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland Dreier <rdreier@cisco.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: [Patch RFC 29/37] infiniband: Make user_mad semaphore a real
 one
In-Reply-To: <adaocr6149h.fsf@cisco.com>
Message-ID: <alpine.LFD.2.00.0907271828000.2936@localhost.localdomain>
References: <20090726081459.455111897@linutronix.de> <20090726081557.120760694@linutronix.de> <adaocr6149h.fsf@cisco.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, Roland Dreier wrote:

> 
>  > -	init_MUTEX(&port->sm_sem);
>  > +	semaphore_init(&port->sm_sem);
> 
> OK by me -- although I'm not clear what's wrong with using existing
> sema_init().

I'm happy do redo the series with sema_init(sem, x) :)

    tglx
 
