Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbZBWWmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbZBWWmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZBWWmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:42:06 -0500
Received: from THUNK.ORG ([69.25.196.29]:43845 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbZBWWmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:42:05 -0500
Date: Mon, 23 Feb 2009 17:41:41 -0500
From: Theodore Tso <tytso@mit.edu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090223224141.GI19739@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
	linux-kbuild@vger.kernel.org
References: <y0mocwuptbc.fsf@ton.toronto.redhat.com> <1235304876.4632.10.camel@laptop> <20090222122424.GA9951@redhat.com> <1235387487.4645.28.camel@laptop> <20090223154404.GA30147@redhat.com> <1235406159.4645.366.camel@laptop> <20090223171032.GA2566@redhat.com> <alpine.DEB.2.00.0902231228420.18221@gandalf.stny.rr.com> <20090223183220.GE19739@mit.edu> <1235427419.4645.959.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235427419.4645.959.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 11:16:59PM +0100, Peter Zijlstra wrote:
> 
> We're working on adding arguments to the function/graph tracer, it would
> fit all your above requirements and doesn't need any source modification
> to boot.

*Excellent*.  I would love to have that funtionality.  How do you plan
to make available complex data structures (i.e., suppose I want
inode->i_ino printed out)?  I assume this will require writing some
"easy to generate" glue code that would presumably be some kind of
kernel module?  That doesn't bother me (after all that's what
SystemTap does), as long as generation of the glue code can be largely
automated ---- so that you can take something approximately like a
DTrace or SystemTap script, and with some perl or python helper,
translate it into glue code that gets compiled into a kernel module.
Is something like that what you have in mind?

   	        	     	       	    	     	- Ted
