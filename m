Return-Path: <linux-kernel-owner+w=401wt.eu-S932275AbXKOUzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbXKOUzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbXKOUze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:55:34 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:45082 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbXKOUzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:55:33 -0500
Date: Thu, 15 Nov 2007 15:54:28 -0500 (EST)
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
Message-ID: <Pine.LNX.4.58.0711151551570.27347@gandalf.stny.rr.com>
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

<snip!>

>
>    As always thanks the the rt-kernel team for all you do.

On behalf of the rt-kernel team, you are welcome ;-)

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

Definitely looks like a config bug. You can send me your config off
list.

Hmm, I need to do a allyesconfig, but I'm not even sure 2.6.24-rc2 would
compile with that.

Thanks,

-- Steve
