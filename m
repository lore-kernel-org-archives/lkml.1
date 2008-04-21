Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbYDUQPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbYDUQPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbYDUQPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:15:39 -0400
Received: from ozlabs.org ([203.10.76.45]:40073 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbYDUQPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:15:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [DOC PATCH] Remove mention of semaphores from kernel-locking
Date: Tue, 22 Apr 2008 02:15:30 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>
References: <20080421145230.GX20637@parisc-linux.org>
In-Reply-To: <20080421145230.GX20637@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804220215.30855.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2008 00:52:30 Matthew Wilcox wrote:
> Since the consensus seems to be to eliminate semaphores where possible,
> we shouldn't be educating people about how to use them as locks.

Agreed.

> Use 
> mutexes instead.  Semaphores should be described in a separate document
> if we end up keeping them.
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
>
> (I'll put this patch in the semaphore git tree tomorrow unless I hear
> complaints.)
>
> diff --git a/Documentation/DocBook/kernel-locking.tmpl
> b/Documentation/DocBook/kernel-locking.tmpl index 435413c..e1f4655 100644
> --- a/Documentation/DocBook/kernel-locking.tmpl
> +++ b/Documentation/DocBook/kernel-locking.tmpl
> @@ -222,7 +222,7 @@
>     <title>Three Main Types of Kernel Locks: Spinlocks, Mutexes and
> Semaphores</title>
>
>     <para>
> -     There are three main types of kernel locks.  The fundamental type
> +     There are two main types of kernel locks.  The fundamental type
>       is the spinlock
>       (<filename class="headerfile">include/asm/spinlock.h</filename>),
>       which is a very simple single-holder lock: if you can't get the

Fix title, too?

Thanks for the other fixes too; this document needs some love,

Acked,
Rusty.
