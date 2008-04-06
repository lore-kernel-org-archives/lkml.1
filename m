Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYDFU3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYDFU3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 16:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYDFU3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 16:29:33 -0400
Received: from ozlabs.org ([203.10.76.45]:56235 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbYDFU3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 16:29:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Fix booting pentium+ with dodgy TSC
Date: Mon, 7 Apr 2008 06:29:07 +1000
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       "H. Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       lguest <lguest@ozlabs.org>, Thomas Gleixner <tglx@linutronix.de>
References: <200804061723.38766.rusty@rustcorp.com.au> <20080406112207.GA26510@elte.hu>
In-Reply-To: <20080406112207.GA26510@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804070629.07704.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 April 2008 21:22:08 Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > Linus please apply.  Almost by definition this patch can't make things
> > worse.
>
> well, while i agree with the patch it could make things worse. In this
> case it can cause code that has been compiled to rely on TSC to
> malfunction. For if sched_clock() was using cpu_has_tsc it could return
> 0 all the time, breaking the scheduler without the user having a clear
> idea why it broke. It isnt, and sched_clock() will work fine, but still,
> your "this cant make things worse" statement is not completely correct.

Hence the "almost".  It can't break machines, but it could make the problem 
harder to diagnose.  Given that it will unbreak at least one machine, I'm 
reasonably confident it's a win :)

>  Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks!
Rusty.
