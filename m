Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbXINENT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbXINENT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 00:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXINENL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 00:13:11 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:18244 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbXINENL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 00:13:11 -0400
Date: Thu, 13 Sep 2007 21:12:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Wilder <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, SystemTAP <systemtap@sources.redhat.com>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] Trace code and documentation
Message-Id: <20070913211210.1c21708c.randy.dunlap@oracle.com>
In-Reply-To: <46E9CB14.7060000@us.ibm.com>
References: <46E9CB14.7060000@us.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 16:43:16 -0700 David Wilder wrote:


> [it would be easier to review and make sense of the comments
> if the patch were inline instead of attached]


Tom Zanussi <zanussi@us.ibm.com>
Martin Hunt <hunt@redhat.com>
David Wilder <dwilder@us.ibm.com>

Above needs to use Signed-off-by: if you want this merged.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

trace.txt:

+When using the READ(2) interface,

s/READ/read/

+   preemption is disabled and that trace state is  set to "running". a

s/. a/. A/

+on the function do_fork(). The value of current->pid is writen to

s/writen/written/

+You can build the kernel module fork_trace.ko using the following
+Makefile:

There was reportedly a discussion about sample source code in the
Documentation/ directory at the kernel summit.  Some people want to
move it to the util-linux package.  If that's not done, I strongly
prefer that Makefiles and source files be put into their own
sub-directory, not "hidden" inside txt files, so you would end up
with something line Documentation/trace/, with trace.txt, and also
Documentation/trace/src, with Makefile and fork_trace.c & any other
source files.

+Trace is adapted from blktrace authored by Jens Axboe (axboe@suse.de).

MAINTAINERS file says <axboe@kernel.dk>.  He's also
<jens.axboe@oracle.com>.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

lib/trace.c:

+ * Based on blktrace code, Copyright (C) 2006 Jens Axboe <axboe@suse.de>

Ditto.

+
+

Use just one blank line between functions and/or structs.

Please check the patch with scripts/checkpatch.pl and then evaluate
its warnings.  Sometimes it makes sense to ignore some of them.

+/**
+ *	trace_setup: create a new trace trace handle
+ *
+ *	@root: The root directory name in the root of the debugfs
+ *	       to place trace directories. Created as needed.

Thanks for using kernel-doc; however, don't put a blank line between
the function name line and the parameters.  Also, the function
name line should have a "-" separating the function name and the
short description.  (multiple places in trace.c)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
