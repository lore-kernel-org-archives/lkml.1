Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0BJKpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 05:45:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab0BJKpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:45:42 -0500
Date: Wed, 10 Feb 2010 11:44:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 2/4] x86, ptrace: regset extensions to support xstate
Message-ID: <20100210104430.GA4546@redhat.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com> <20100209202502.216592031@sbs-t61.sc.intel.com> <20100210013031.208FB73D8@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210013031.208FB73D8@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09, Roland McGrath wrote:
>
> > @@ -204,8 +209,6 @@ int xfpregs_set(struct task_struct *targ
> >  	if (ret)
> >  		return ret;
> >
> > -	set_stopped_child_used_math(target);
> > -
>
> You didn't mention this change in a comment or log entry.
> It looks like it's superfluous after init_fpu.  So this change
> is right, but AFAICT it belongs in an entirely separate patch
> and has nothing to do with xsave support.

I guess Suresh was going to change xstateregs_set() added by this patch,
it also sets USED_MATH after init_fpu().

Oleg.

