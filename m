Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbZHYNje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbZHYNje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 09:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZHYNjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 09:39:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbZHYNjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:39:32 -0400
Date: Tue, 25 Aug 2009 09:37:16 -0400
From: Jason Baron <jbaron@redhat.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, fweisbec@gmail.com,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com, jistone@redhat.com,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH 1/4] add NR_syscalls define for x86
Message-ID: <20090825133716.GA2656@redhat.com>
References: <cover.1251146512.git.jbaron@redhat.com> <0f33c0f96d198fccc3ddd9ff7f5334ff5cb42706.1251146513.git.jbaron@redhat.com> <20090824220531.GA20832@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824220531.GA20832@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 07:05:32AM +0900, Paul Mundt wrote:
> On Mon, Aug 24, 2009 at 05:40:14PM -0400, Jason Baron wrote:
> > Add a NR_syscalls #define for x86. This is used in the syscall events tracing
> > code. Todo: make it dynamic like x86_64
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> > 
> > ---
> >  arch/x86/include/asm/unistd_32.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
> > index 732a307..8deaada 100644
> > --- a/arch/x86/include/asm/unistd_32.h
> > +++ b/arch/x86/include/asm/unistd_32.h
> > @@ -345,6 +345,8 @@
> >  
> >  #ifdef __KERNEL__
> >  
> > +#define NR_syscalls 337
> > +
> Syscalls start at 0 and end at 337, there are 338 syscalls, not 337.
> Hence the off-by-1 that I initially reported. NR_syscalls is always the
> last syscall + 1.

right, as I explained in my 0/4 message, this patch is for the -tip tree,
where 337 is correct, and needs to be adjusted for the -next tree to 338.

thanks,

-Jason

