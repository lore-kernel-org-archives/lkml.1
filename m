Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYGNT72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYGNT72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 15:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbYGNT7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 15:59:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60360 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbYGNT7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 15:59:20 -0400
Date: Mon, 14 Jul 2008 15:59:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: David Teigland <teigland@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH] ftrace: Documentation
In-Reply-To: <20080714180237.GB11644@redhat.com>
Message-ID: <Pine.LNX.4.58.0807141558100.30575@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
 <20080714180237.GB11644@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, David Teigland wrote:

>
> On Thu, Jul 10, 2008 at 12:46:01PM -0400, Steven Rostedt wrote:
> > +The File System
> > +---------------
> > +
> > +Ftrace uses the debugfs file system to hold the control files as well
> > +as the files to display output.
> > +
> > +To mount the debugfs system:
> > +
> > +  # mkdir /debug
> > +  # mount -t debugfs nodev /debug
>
>
> I believe /sys/kernel/debug is the proper mount point.

I've heard about that, but it just seems like a deep path. I can mention
that at the begining of the document then say:

 For shorter path names in the following examples, we will simply mount
 the debugfs at /debug.

-- Steve

