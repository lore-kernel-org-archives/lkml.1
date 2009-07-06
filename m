Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZGFS4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZGFS4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 14:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZGFS4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 14:56:14 -0400
Received: from www.tglx.de ([62.245.132.106]:54618 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbZGFS4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 14:56:14 -0400
Date: Mon, 6 Jul 2009 20:54:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Christoph Lameter <cl@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: thread_info.h moving comment to where it should
 be
In-Reply-To: <1246879925.28541.3.camel@hpdv5.satnam>
Message-ID: <alpine.LFD.2.00.0907062052230.19480@localhost.localdomain>
References: <1246879925.28541.3.camel@hpdv5.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009, Jaswinder Singh Rajput wrote:
> 
> By mistake commit 2052e8d40ad58 moved following comment to wrong place,
> where it does not make any sense :

Wrong. commit 2052e8d4 had the comments in the right place. commit
3351cc03 replaced the two identical INIT_THREAD_INFO macros and did
not update the comments.

>  #define STACK_WARN	(THREAD_SIZE/8)
> +

How is that related ?

>  /*
>   * macros/functions for gaining access to the thread information structure
> - *
> - * preempt_count needs to be 1 initially, until the scheduler is functional.
>   */
>  #ifndef __ASSEMBLY__
>  
> -

Ditto.

Thanks,

	tglx
