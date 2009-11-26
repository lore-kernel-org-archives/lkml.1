Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbZKZHHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbZKZHHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbZKZHHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:07:48 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49498 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbZKZHHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:07:48 -0500
Date: Thu, 26 Nov 2009 12:37:47 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       utrace-devel@redhat.com, Alexey Dobriyan <adobriyan@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
Message-ID: <20091126070747.GA30231@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20091124200127.GA5751@redhat.com> <20091125214818.GA4916@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125214818.GA4916@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph, 

> 
> The other thing is that this patchset really doesn't quite justify
> utrace.  It's growing a lot more code without actually growing any
> useful functionality.  What about all those other utrace killer
> features that have been promised for a long time?
> 

We are working on in-kernel gdbstub which was one of the features that
you had asked for. gdbstub does pass unit tests; but we are looking at
some way to hack the GDB testsuite to run its regression tests. Once we
are able to run the GDB testsuite and utrace is part of some upstream
tree, we plan to post these patches to LKML for comments. gdbstub uses
utrace and uprobes underneath. Uprobes was rewritten to remove issues
that LKML developers had opposed. Uprobes also has its own ftrace plugin
to use uprobes.

Currently in-kernel gdbstub is hosted by Frank Ch. Eigler over here:
git://web.elastic.org/~fche/utrace-ext.git
branch name utrace-gdbstub-uprobes

--
Regards
Srikar
