Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYKLUcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYKLUcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYKLUcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:32:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64845 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbYKLUcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:32:32 -0500
Date: Wed, 12 Nov 2008 15:32:29 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>, fweisbec@gmail.com
Subject: Re: [PATCH 1/2] ftrace: disable tracing on resize
In-Reply-To: <20081112215630.242ce97e@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0811121531490.17319@gandalf.stny.rr.com>
References: <20081111025808.946638585@goodmis.org> <20081111030517.017566077@goodmis.org> <alpine.DEB.1.10.0811102216240.10298@gandalf.stny.rr.com> <20081112215630.242ce97e@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 12 Nov 2008, Pekka Paalanen wrote:

> On Mon, 10 Nov 2008 22:18:19 -0500 (EST)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Pekka,
> > 
> > I forgot to add you to the Cc list. Could you test this patch to see if it 
> > fixes the bug you reported. It fixed a bug I was able to reproduce, but I 
> > was never able to reproduce the exact same bug you have seen.
> 
> Thanks, Steve.
> 
> I didn't have time to try it myself yet, but a kind soul tried it for me.
> He used 2.6.28-rc4 and was immediately able to trigger the bug by just:
> cd /debug/tracing
> echo 0 > tracing_enabled
> echo 200 > trace_entries
> 
> Then he applied the patch you referred to, and the bug is still present.
> He has a 32-bit x86 amd system, and I'm on x86_64.
> 
> I don't know why you couldn't reproduce it, maybe you have all the tracers
> enabled in the kernel config, when we only have MMIOTRACE.
> 
> I can't promise to look into this deeper in the near future :-/
> 

OK, I'll disable everything but MMIOTRACE and see if I can reproduce it.

Thanks,

-- Steve

