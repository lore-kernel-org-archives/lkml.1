Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbZA3BMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbZA3BMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZA3BMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:12:09 -0500
Received: from ozlabs.org ([203.10.76.45]:48205 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZA3BMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:12:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
Date: Fri, 30 Jan 2009 11:41:57 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, jens.axboe@oracle.com
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com> <1233218954.7835.11.camel@twins> <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301141.58591.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009 01:38:01 Steven Rostedt wrote:
> 
> The smp_call_function can be passed a wait parameter telling it to
> wait for all the functions running on other CPUs to complete before
> returning, or to return without waiting. Unfortunately, this is
> currently just a suggestion and not manditory. That is, the
> smp_call_function can decide not to return and wait instead.

I think the file could probably use some comment love and the comments
made more pithy (the correct comment in the "kmalloc failed" path usually
involves cussing), but we can't have everything.

Not that it matters, but since I was the last one to touch this file:
Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
