Return-Path: <linux-kernel-owner+w=401wt.eu-S1764378AbXJEXOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764378AbXJEXOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 19:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761412AbXJEXOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 19:14:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58900 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761530AbXJEXOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 19:14:22 -0400
Date: Fri, 5 Oct 2007 16:13:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: nickpiggin@yahoo.com.au, randy.dunlap@oracle.com, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag fixes
Message-Id: <20071005161305.af27f452.akpm@linux-foundation.org>
In-Reply-To: <20071003114401.32194.73464.sendpatchset@jackhammer.engr.sgi.com>
References: <20071003114401.32194.73464.sendpatchset@jackhammer.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Oct 2007 04:44:01 -0700
Paul Jackson <pj@sgi.com> wrote:

> From: Paul Jackson <pj@sgi.com>
> 
> Thanks to Randy Dunlap for the review that caught
> some of the following.
> 
> Some bug fixes and coding style fixes:
>  1) only one statement per line, please.
>  2) don't need to guard kfree() calls with a NULL check
>  3) use kfifo_free, not kfree, if it came from kfifo_alloc
>  4) a pair of curly brackets got lost along the way
>  5) missing .read, .write callbacks for sched_load_balance
> 
> Without (3), one kfifo buffer memory was leaked each time
> one rebuilt scheduler domains
> 
> Without (4), the current task was summarily killed each
> time one tried to rebuild scheduler domains
> 
> Without (5), every read or write system call on a per-cpuset
> special file 'sched_load_balance' failed, EINVAL.
> 
> Signed-off-by: Paul Jackson <pj@sgi.com>
> 
> ---
> 
> Andrew,
> 
>   These fixes go right after the patch they fix:
>     [PATCH] cpuset and sched domains: sched_load_balance flag

I'm getting 100% rejects from this - probably whatever patch it is
patching got lost or unrecognisably mangled.
