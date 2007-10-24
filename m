Return-Path: <linux-kernel-owner+w=401wt.eu-S1760562AbXJXRbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562AbXJXRbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760185AbXJXRbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:31:10 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:50714 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760151AbXJXRbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:31:05 -0400
Date: Wed, 24 Oct 2007 13:31:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jeff Garzik <jeff@garzik.org>, Sam Ravnborg <sam@ravnborg.org>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC] create instrumentation/ directory
Message-ID: <20071024173102.GA29958@Krystal>
References: <20071024095226.GA30326@havoc.gtf.org> <20071024130557.GA18610@Krystal> <471F4649.3000000@garzik.org> <20071024091240.7978c2da.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071024091240.7978c2da.rdunlap@xenotime.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:14:47 up 86 days, 17:33,  2 users,  load average: 4.89, 2.39, 1.12
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (rdunlap@xenotime.net) wrote:
> On Wed, 24 Oct 2007 09:19:05 -0400 Jeff Garzik wrote:
> 
> > Honestly, I don't care at all about building the code.  If that's what 
> > you want, great.
> 
> Yes, that is wanted.  They bitrot too easily -- not good.
> 
> > My objection is more to adding a samples/ directory, which is contra to 
> > past experience:
> > 
> > A new net driver sample should go in drivers/net/ like the existing 
> > skeleton files I already listed, not samples/net/.  A top-level 
> 
> Can't disagree with that.
> 
> > "samples/" seems like it exists only duplicate the rest of the tree 
> > hierarchy.
> 
> It seems odd to be building code in Documentation/, but I can live
> with that.  It was primarily Christoph who was opposed to that.
> He suggested samples/ and I went along with it just to break the
> impasse (since no one else was making any comments on it at that
> time).
> 
> Sam, would building code in Documentation/ cause problems for
> kbuild?

Since we already have the Instrumentation menu in
kernel/Kconfig.instrumentation and instrumentation code all over the
kernel tree:

arch/*/oprofile/*.c
kernel/kprobes.c
arch/*/kernel/kprobes.c
kernel/marker.c
kernel/profile.c
kernel/profile.S
kernel/lockdep.c
vm/vmstat.c
block/blktrace.c

We could move them to 

instrumentation/
arch/*/instrumentation/

Therefore, we could also move the kprobes and marker samples under

instrumentation/samples/

My main concern is that 15 characters long directory name might be
inelegant (however, it only beats Documentation by 2).

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
