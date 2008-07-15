Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbYGODcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbYGODcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYGODcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:32:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51079 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbYGODcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:32:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Elias Oltmanns <eo@nebensachen.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
	<87zlop7bp6.fsf@denkblock.local>
	<20080710132832.38cc5048.randy.dunlap@oracle.com>
	<Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com>
	<Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com>
	<20080711121655.05810822.akpm@linux-foundation.org>
	<Pine.LNX.4.58.0807111546560.25977@gandalf.stny.rr.com>
	<20080711153740.b86acadd.akpm@linux-foundation.org>
	<m13amg9fl0.fsf@frodo.ebiederm.org>
	<Pine.LNX.4.58.0807142105390.2955@gandalf.stny.rr.com>
	<m1r69wj5t8.fsf@frodo.ebiederm.org>
	<Pine.LNX.4.58.0807142142070.4223@gandalf.stny.rr.com>
	<m13ambkivq.fsf@frodo.ebiederm.org>
	<Pine.LNX.4.58.0807142212030.4530@gandalf.stny.rr.com>
	<m1fxqbj2c4.fsf@frodo.ebiederm.org>
	<Pine.LNX.4.58.0807142302400.4530@gandalf.stny.rr.com>
Date: Mon, 14 Jul 2008 20:29:14 -0700
In-Reply-To: <Pine.LNX.4.58.0807142302400.4530@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Mon, 14 Jul 2008 23:05:08 -0400 (EDT)")
Message-ID: <m1r69vhlkl.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Steven Rostedt <rostedt@goodmis.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0106]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH -v2] ftrace: Documentation
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> Is there documentation around to let me know the proper way to use the pid
> namespace API?  I think ftrace should be updated before 2.6.27 is
> released, to use the pid namespaces. There's some other clean ups I need
> to do.

There are the bits in sched.h and pid.h I don't think there are any
detailed docs on how to convert a subsystem.

Not that there aren't good examples.  It is just generally assumed
that we won't be adding many more subsystems using pids.

> Note: I'll be traveling from Weds through to the 28th. I need to write up
> my tutorial for OLS on ftrace and will not be doing many patches for the
> next two weeks.

Well if you get stuck perhaps we can talk at OLS.

Eric
