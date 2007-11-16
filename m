Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbXKPDk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbXKPDk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 22:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757546AbXKPDkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 22:40:17 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:44734 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421AbXKPDkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 22:40:15 -0500
Date: Thu, 15 Nov 2007 22:39:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mark Knecht <markknecht@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Daniel Walker <dwalker@mvista.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: 2.6.24-rc2-rt1
In-Reply-To: <5bdc1c8b0711151241j5f1b8427w38d2a286eb6ebb7f@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0711152232100.31778@gandalf.stny.rr.com>
References: <1195152030.13982.48.camel@localhost.localdomain>
 <5bdc1c8b0711151241j5f1b8427w38d2a286eb6ebb7f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Nov 2007, Mark Knecht wrote:

> On Nov 15, 2007 10:40 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Finally!
> >
> > We are pleased to announce 2.6.24-rc2-rt1.
> >
> <SNIP>
>
> Hi Steve,
>    Not sure I've ever posted on this list. Always looking to help out
> at my low level.
>
>    Anyway, I tried building the kernel. My 1st two attempts, done
> running make menuconfig from scratch, didn't boot. I gave up on that
> for now and tried using make oldconfig from my 2.6.23-rt1 kernel (I'm
> so far behind!!) and ended up with this error. Not sure it's enough
> for you to find the bug. If you want/need more or want the config file
> let me know.
>
>    I'm sure this is just me setting inappropriate bits but I figured I
> might as well send along the info. >/dev/null if it's inappropriate
> but let me know how to move forward if possible.
>
>    As always thanks the the rt-kernel team for all you do.
>
> Cheers,
> Mark
>
>   CC      ipc/mqueue.o
>   CC      ipc/compat_mq.o
>   LD      ipc/built-in.o
>   CC      security/security.o
>   CC      security/dummy.o
>   CC      security/inode.o
>   LD      security/built-in.o
>   CC [M]  security/commoncap.o
>   CC [M]  security/realcap.o
> security/realcap.c: In function 'realtime_exit':
> security/realcap.c:129: error: implicit declaration of function
> 'mod_unreg_security'
> security/realcap.c:133: error: implicit declaration of function
> 'unregister_security'
> make[1]: *** [security/realcap.o] Error 1
> make: *** [security] Error 2
> lightning linux #

Hi Mark,

I guess you enabled the realtime capabilities (Realtime-LSM - Obsolete -)

You could disable that, and try again. I'm not sending a fix (yet)
because ...


Ingo,

Do we still need to have the realtime-lsm.patch? It has been considered
obsolete for over a year now. Can we finally remove it.

-- Steve

