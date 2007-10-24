Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbXJXQMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbXJXQMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbXJXQMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:12:45 -0400
Received: from xenotime.net ([66.160.160.81]:58622 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752711AbXJXQMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:12:44 -0400
Date: Wed, 24 Oct 2007 09:12:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Sam Ravnborg <sam@ravnborg.org>, Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/git patch] move samples/ to Documentation/markers/
Message-Id: <20071024091240.7978c2da.rdunlap@xenotime.net>
In-Reply-To: <471F4649.3000000@garzik.org>
References: <20071024095226.GA30326@havoc.gtf.org>
	<20071024130557.GA18610@Krystal>
	<471F4649.3000000@garzik.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 09:19:05 -0400 Jeff Garzik wrote:

> Honestly, I don't care at all about building the code.  If that's what 
> you want, great.

Yes, that is wanted.  They bitrot too easily -- not good.

> My objection is more to adding a samples/ directory, which is contra to 
> past experience:
> 
> A new net driver sample should go in drivers/net/ like the existing 
> skeleton files I already listed, not samples/net/.  A top-level 

Can't disagree with that.

> "samples/" seems like it exists only duplicate the rest of the tree 
> hierarchy.

It seems odd to be building code in Documentation/, but I can live
with that.  It was primarily Christoph who was opposed to that.
He suggested samples/ and I went along with it just to break the
impasse (since no one else was making any comments on it at that
time).

Sam, would building code in Documentation/ cause problems for
kbuild?

---
~Randy
