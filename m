Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbYGOX0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbYGOX0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbYGOX0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:26:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003AbYGOX0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:26:30 -0400
Date: Tue, 15 Jul 2008 16:24:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
       greg@kroah.com, nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/7] dynamic debug v2 - nfs conversion
Message-Id: <20080715162441.4aa011e0.akpm@linux-foundation.org>
In-Reply-To: <1216163745.7981.90.camel@localhost>
References: <20080715213241.GC23331@redhat.com>
	<1216161003.7981.73.camel@localhost>
	<20080715154323.b7d5f14d.akpm@linux-foundation.org>
	<1216162567.7981.82.camel@localhost>
	<1216163745.7981.90.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 19:15:45 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Tue, 2008-07-15 at 18:56 -0400, Trond Myklebust wrote:
> 
> > The point is that he is changing a semi-official interface for tracing
> > the NFS kernel activity from userspace. I'd like to know why and how it
> > is being modified before I can ack it.
> > 
> > In addition there are several other developers who have a daily interest
> > in using this interface when helping our users, and who might have
> > comments.
> 
> OK. Having looked up the missing patch on gmane, I'd like to know
> whether or not there is a followup plan to fix up utilities like
> 'rpcdebug'? Apparently this patch doesn't remove the existing sunrpc
> sysctl interface, but does circumvent it. The result is that while
> rpcdebug will happily continue to run, it just won't work any more...
> 

I'm suspecting that Jason chose the wrong starter subsystem here ;)
Probably we should have started with the many hundreds of simpler
cases.

OTOH, it's important that Jason understand NFS's requirements here. 
Treat it as a testcase for his design.  Will his infrastructure be
usable by NFS?  If not, does his infrastructure need generalising and
strengthening so that it _does_ suit?

