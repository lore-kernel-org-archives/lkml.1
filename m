Return-Path: <linux-kernel-owner+w=401wt.eu-S1761783AbYGODFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761783AbYGODFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbYGODFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:05:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41283 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbYGODFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:05:09 -0400
Date: Mon, 14 Jul 2008 23:05:08 -0400 (EDT)
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
In-Reply-To: <m1fxqbj2c4.fsf@frodo.ebiederm.org>
Message-ID: <Pine.LNX.4.58.0807142302400.4530@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
 <87zlop7bp6.fsf@denkblock.local> <20080710132832.38cc5048.randy.dunlap@oracle.com>
 <Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com>
 <20080711121655.05810822.akpm@linux-foundation.org>
 <Pine.LNX.4.58.0807111546560.25977@gandalf.stny.rr.com>
 <20080711153740.b86acadd.akpm@linux-foundation.org> <m13amg9fl0.fsf@frodo.ebiederm.org>
 <Pine.LNX.4.58.0807142105390.2955@gandalf.stny.rr.com> <m1r69wj5t8.fsf@frodo.ebiederm.org>
 <Pine.LNX.4.58.0807142142070.4223@gandalf.stny.rr.com> <m13ambkivq.fsf@frodo.ebiederm.org>
 <Pine.LNX.4.58.0807142212030.4530@gandalf.stny.rr.com> <m1fxqbj2c4.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 14 Jul 2008, Eric W. Biederman wrote:
>
> All of the interesting functions are inline so it shouldn't be a big deal.
> Mostly they exist to keep the semantics clear as we refactor the code.
> task_pid_nr(tsk) yields the global pid number, and is currently implemented as just tsk->pid.
> task_pid(tsk) yields the struct pid.
>
> task_pid_nr_ns(tsk) yields the pid number from the perspective of a specific
> task.
>
> struct pid is interesting because it is immune from pid roll over conflicts.
> I don't know if that is any use to you or not.
>
> stuct pid contains an embedded array of the pid_nrs one for each namespace the
> struct pid is in.

Is there documentation around to let me know the proper way to use the pid
namespace API?  I think ftrace should be updated before 2.6.27 is
released, to use the pid namespaces. There's some other clean ups I need
to do.

Note: I'll be traveling from Weds through to the 28th. I need to write up
my tutorial for OLS on ftrace and will not be doing many patches for the
next two weeks.

-- Steve

