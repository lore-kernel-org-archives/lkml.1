Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbZKZMz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbZKZMz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 07:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbZKZMz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 07:55:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53117 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbZKZMz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 07:55:56 -0500
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       utrace-devel@redhat.com, Alexey Dobriyan <adobriyan@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>
In-Reply-To: <20091126070747.GA30231@linux.vnet.ibm.com>
References: <20091124200127.GA5751@redhat.com>
	 <20091125214818.GA4916@infradead.org>
	 <20091126070747.GA30231@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Nov 2009 13:55:52 +0100
Message-ID: <1259240152.4273.83.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 12:37 +0530, Srikar Dronamraju wrote:
> Hi Christoph, 
> 
> > 
> > The other thing is that this patchset really doesn't quite justify
> > utrace.  It's growing a lot more code without actually growing any
> > useful functionality.  What about all those other utrace killer
> > features that have been promised for a long time?
> > 
> 
> We are working on in-kernel gdbstub which was one of the features that
> you had asked for. gdbstub does pass unit tests; but we are looking at
> some way to hack the GDB testsuite to run its regression tests. Once we
> are able to run the GDB testsuite and utrace is part of some upstream
> tree, we plan to post these patches to LKML for comments. gdbstub uses
> utrace and uprobes underneath. Uprobes was rewritten to remove issues
> that LKML developers had opposed. Uprobes also has its own ftrace plugin
> to use uprobes.
> 
> Currently in-kernel gdbstub is hosted by Frank Ch. Eigler over here:
> git://web.elastic.org/~fche/utrace-ext.git
> branch name utrace-gdbstub-uprobes

If its anywhere near functioning it would have made sense to send it out
as an RFC patch-set right along with the utrace one.
