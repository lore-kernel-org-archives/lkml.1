Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbYGOBn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbYGOBn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 21:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYGOBns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 21:43:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56640 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYGOBns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 21:43:48 -0400
Date: Mon, 14 Jul 2008 21:43:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Elias Oltmanns <eo@nebensachen.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH -v2] ftrace: Documentation
In-Reply-To: <m1r69wj5t8.fsf@frodo.ebiederm.org>
Message-ID: <Pine.LNX.4.58.0807142142070.4223@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
 <87zlop7bp6.fsf@denkblock.local> <20080710132832.38cc5048.randy.dunlap@oracle.com>
 <Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com>
 <20080711121655.05810822.akpm@linux-foundation.org>
 <Pine.LNX.4.58.0807111546560.25977@gandalf.stny.rr.com>
 <20080711153740.b86acadd.akpm@linux-foundation.org> <m13amg9fl0.fsf@frodo.ebiederm.org>
 <Pine.LNX.4.58.0807142105390.2955@gandalf.stny.rr.com> <m1r69wj5t8.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 14 Jul 2008, Eric W. Biederman wrote:

>
> Steven Rostedt <rostedt@goodmis.org> writes:
>
> > Actually it is a /debug (or /sys/mount/debug if you prefer) file.
>
> Got it.  I haven't ever actually seen anyone use debugfs.
>
> > I'd be interested in knowing who would want namespaces in traces. I've
> > basically only used tracing to see "what's happening in the kernel here?".
> > Where I only use the pid to differentiate between the tasks I know are
> > running.
>
> > Hence, tracing is much like printk. Does it really matter with these
> > outputs. But ftrace is pluggable, pid namespaces may matter in future
> > plugins.

Bare with me, I'm new to the namespace concept of pids.

>
> So it would not be hard to capture the pid namespace in mount or
> even look at current to get it (although the last is a little odd).

>From userspace or from with the kernel (doing the trace)

>
> I'm not at all certain if it makes sense.  If this is something
> an ordinary user could use then we definitely want to do something.
>
> Is tracing possible without inserting kernel modules?

The tracer is built into the kernel (no module needed).

-- Steve

