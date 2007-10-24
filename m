Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbXJXQQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbXJXQQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbXJXQQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:16:01 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41181 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbXJXQQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:16:00 -0400
Date: Wed, 24 Oct 2007 18:17:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jeff Garzik <jeff@garzik.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/git patch] move samples/ to Documentation/markers/
Message-ID: <20071024161731.GB3166@uranus.ravnborg.org>
References: <20071024095226.GA30326@havoc.gtf.org> <20071024130557.GA18610@Krystal> <471F4649.3000000@garzik.org> <20071024091240.7978c2da.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024091240.7978c2da.rdunlap@xenotime.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 09:12:40AM -0700, Randy Dunlap wrote:
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
I have this pipe dream that we shall introduce a tool to make the
.txt doc readable in some popular format (HTML?) and then we would
have that Makefile in Documentation/ but that could be a special target
so should be OK.

	Sam
