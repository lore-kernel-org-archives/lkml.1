Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZLHIFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZLHIFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZLHIFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:05:14 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:46271 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbZLHIFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:05:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vx4xykZBc1mcCHz9KLQ6k9D2zGM6Jn0WkJQcK5llHBKJeHwY4ic2XlrMzdnuKd8GVf
         Zfcp5biU60TZClFqzHryPEBQKel05zOSF2mXsYGiJ/iWq4AH4jEl9f+JO6soH99pe94Z
         y3jHzE/xfV0hAUduxdpR9ee7DnYMbhhVToR1w=
Date: Tue, 8 Dec 2009 09:05:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: percpu/tip tree build failure
Message-ID: <20091208080509.GD4989@nowhere>
References: <20091208182515.bb6dda4a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208182515.bb6dda4a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 06:25:15PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> kernel/hw_breakpoint.c:86: error: 'task_bp_pinned' redeclared as different kind of symbol
> kernel/hw_breakpoint.c:55: note: previous declaration of 'task_bp_pinned' was here
> kernel/hw_breakpoint.c: In function 'toggle_bp_task_slot':
> kernel/hw_breakpoint.c:165: warning: assignment from incompatible pointer type
> 
> Caused by commit dd17c8f72993f9461e9c19250e3f155d6d99df22 ("percpu:
> remove per_cpu__ prefix") from the percpu tree interacting with commit
> 56053170ea2a2c0dc17420e9b94aa3ca51d80408 ("hw-breakpoints: Fix task-bound
> breakpoint slot allocation") from the tip tree.
> 
> I have applied the following patch for today (and can carry it as
> necessary:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 8 Dec 2009 18:19:48 +1100
> Subject: [PATCH] percpu: make per_cpu variable name unique in hw_breakpoint.c
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>


Doh!

Thanks Stephen.

Ingo, can you queue up this patch?

Thanks.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

