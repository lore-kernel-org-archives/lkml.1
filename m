Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbYLKBLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbYLKBLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 20:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbYLKBLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 20:11:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59129 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbYLKBLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 20:11:05 -0500
Date: Wed, 10 Dec 2008 20:11:02 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] make INIT_FS use the __RW_LOCK_UNLOCKED initialization
In-Reply-To: <8bd0f97a0812101707p7df7745dk9840b05c0b26184b@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812102010100.29200@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812101832200.21545@gandalf.stny.rr.com>  <20081210234307.GI28946@ZenIV.linux.org.uk> <8bd0f97a0812101707p7df7745dk9840b05c0b26184b@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Dec 2008, Mike Frysinger wrote:

> On Wed, Dec 10, 2008 at 18:43, Al Viro wrote:
> > On Wed, Dec 10, 2008 at 06:37:28PM -0500, Steven Rostedt wrote:
> >>
> >> The following patch is in:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> >>
> >>     branch: cleanups
> >
> > Would be better to take init_fs to something in fs/ or kernel/ and kill
> > the duplicates, along with INIT_FS macro itself...
> 
> how about the next level: unify init_task.c.  a quick check shows that
> like 90% of the stuff in there is the same for everyone ...
> -mike

I could probably do it for x86 and PPC, but beyond that, each arch 
maintainer will have to do it separately. That's a change that would need 
testing.

These changes are trivial (something I need to get RT working).

-- Steve

