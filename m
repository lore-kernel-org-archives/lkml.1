Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZBXI4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZBXI4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 03:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZBXI4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 03:56:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39333 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbZBXI4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 03:56:07 -0500
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
In-Reply-To: <20090223224141.GI19739@mit.edu>
References: <y0mocwuptbc.fsf@ton.toronto.redhat.com>
	 <1235304876.4632.10.camel@laptop> <20090222122424.GA9951@redhat.com>
	 <1235387487.4645.28.camel@laptop> <20090223154404.GA30147@redhat.com>
	 <1235406159.4645.366.camel@laptop> <20090223171032.GA2566@redhat.com>
	 <alpine.DEB.2.00.0902231228420.18221@gandalf.stny.rr.com>
	 <20090223183220.GE19739@mit.edu> <1235427419.4645.959.camel@laptop>
	 <20090223224141.GI19739@mit.edu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 24 Feb 2009 09:55:37 +0100
Message-Id: <1235465737.15790.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 17:41 -0500, Theodore Tso wrote:
> On Mon, Feb 23, 2009 at 11:16:59PM +0100, Peter Zijlstra wrote:
> > 
> > We're working on adding arguments to the function/graph tracer, it would
> > fit all your above requirements and doesn't need any source modification
> > to boot.
> 
> *Excellent*.  I would love to have that funtionality.  How do you plan
> to make available complex data structures (i.e., suppose I want
> inode->i_ino printed out)?  I assume this will require writing some
> "easy to generate" glue code that would presumably be some kind of
> kernel module?  That doesn't bother me (after all that's what
> SystemTap does), as long as generation of the glue code can be largely
> automated ---- so that you can take something approximately like a
> DTrace or SystemTap script, and with some perl or python helper,
> translate it into glue code that gets compiled into a kernel module.
> Is something like that what you have in mind?

Yeah, we were also looking at using sparse and term rewrite systems on
top of the regular C parse tree to generate stuff.

