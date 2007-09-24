Return-Path: <linux-kernel-owner+w=401wt.eu-S1759986AbXIXSOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbXIXSOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbXIXSOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:14:43 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40509 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbXIXSOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:14:42 -0400
Date: Mon, 24 Sep 2007 11:13:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
Message-Id: <20070924111318.f16cde07.randy.dunlap@oracle.com>
In-Reply-To: <20070924180041.GB2435@infradead.org>
References: <20070924164950.006047409@polymtl.ca>
	<20070924165428.335030720@polymtl.ca>
	<20070924175044.GD1608@infradead.org>
	<20070924105632.009aba7f.randy.dunlap@oracle.com>
	<20070924180041.GB2435@infradead.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 19:00:41 +0100 Christoph Hellwig wrote:

> On Mon, Sep 24, 2007 at 10:56:32AM -0700, Randy Dunlap wrote:
> > I don't have a problem with a samples/ directory except (as I have
> > already pointed out) it means that people will end up having to look
> > in 2 places for the information that they need, i.e., both in
> > samples/ and in Documentation/.  So I really don't see a big need
> > to split the samples and docs.
> > 
> > What's wrong with building sample code in the Documentation/ directory?
> 
> It's not really documentation, it's code :)  If you want to build
> documentation from the samples use kerneldoc or similar to extrace the
> comments.  Having Documentation/ purely for things not affecting the build
> make things a whole lot clearer, but if you absolutely insist on it
> we can put it under Documentation/ as long as it's fully integrated into
> kbuild and will be built as part of allmodconfig, unlike the current
> two patches showing code there.
> -

Yes, it has to be integrated into the build system, no doubt.

We really need to give Mathieu and David Wilder an answer so that they
can make progress (and I'm willing to help with this).

To do this, here's my test question:
How much of David's "trace code and documentation" patch can be put
into a samples/ directory?

 Documentation/trace/src/Makefile     |    7 +
 Documentation/trace/src/README       |   18 +
 Documentation/trace/src/fork_trace.c |  119 +++++++
 Documentation/trace/trace.txt        |  164 ++++++++++
 include/linux/trace.h                |   99 ++++++
 lib/Kconfig                          |    9 +
 lib/Makefile                         |    2 +
 lib/trace.c                          |  563 +++++++++++++++++++++++++++
+++++++
 8 files changed, 981 insertions(+), 0 deletions(-)


All of the trace/src/ subdirectory?


---
~Randy
Phaedrus says that Quality is about caring.
