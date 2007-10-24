Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbXJXRsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbXJXRsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbXJXRsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:48:36 -0400
Received: from xenotime.net ([66.160.160.81]:45088 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752218AbXJXRsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:48:35 -0400
Date: Wed, 24 Oct 2007 10:48:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jeff Garzik <jeff@garzik.org>, Sam Ravnborg <sam@ravnborg.org>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] create instrumentation/ directory
Message-Id: <20071024104834.5d4829c5.rdunlap@xenotime.net>
In-Reply-To: <20071024173102.GA29958@Krystal>
References: <20071024095226.GA30326@havoc.gtf.org>
	<20071024130557.GA18610@Krystal>
	<471F4649.3000000@garzik.org>
	<20071024091240.7978c2da.rdunlap@xenotime.net>
	<20071024173102.GA29958@Krystal>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 13:31:02 -0400 Mathieu Desnoyers wrote:

> * Randy Dunlap (rdunlap@xenotime.net) wrote:
> > On Wed, 24 Oct 2007 09:19:05 -0400 Jeff Garzik wrote:
> > 
> > > Honestly, I don't care at all about building the code.  If that's what 
> > > you want, great.
> > 
> > Yes, that is wanted.  They bitrot too easily -- not good.
> > 
> > > My objection is more to adding a samples/ directory, which is contra to 
> > > past experience:
> > > 
> > > A new net driver sample should go in drivers/net/ like the existing 
> > > skeleton files I already listed, not samples/net/.  A top-level 
> > 
> > Can't disagree with that.
> > 
> > > "samples/" seems like it exists only duplicate the rest of the tree 
> > > hierarchy.
> > 
> > It seems odd to be building code in Documentation/, but I can live
> > with that.  It was primarily Christoph who was opposed to that.
> > He suggested samples/ and I went along with it just to break the
> > impasse (since no one else was making any comments on it at that
> > time).
> > 
> > Sam, would building code in Documentation/ cause problems for
> > kbuild?
> 
> Since we already have the Instrumentation menu in
> kernel/Kconfig.instrumentation and instrumentation code all over the
> kernel tree:
> 
> arch/*/oprofile/*.c
> kernel/kprobes.c
> arch/*/kernel/kprobes.c
> kernel/marker.c
> kernel/profile.c
> kernel/profile.S
> kernel/lockdep.c
> vm/vmstat.c
> block/blktrace.c
> 
> We could move them to 
> 
> instrumentation/
> arch/*/instrumentation/
> 
> Therefore, we could also move the kprobes and marker samples under
> 
> instrumentation/samples/
> 
> My main concern is that 15 characters long directory name might be
> inelegant (however, it only beats Documentation by 2).

Ack, instrumentation deserves that much (in the new world order).


---
~Randy
