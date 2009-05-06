Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbZEFJMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbZEFJMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZEFJLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:11:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41763 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZEFJLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:11:54 -0400
Date: Wed, 6 May 2009 05:11:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, jdike@addtoit.com,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] utrace/ptrace: simplify/cleanup ptrace attach
Message-ID: <20090506091115.GA24332@infradead.org>
References: <20090503185537.GA17071@redhat.com> <20090504184951.623CEFC32F@magilla.sf.frob.com> <20090504193016.GA17076@redhat.com> <20090504194348.BC0EBFC32F@magilla.sf.frob.com> <20090504163154.f3672a83.akpm@linux-foundation.org> <20090505230642.GA980@redhat.com> <20090506081225.GD8098@elte.hu> <20090506082300.GA16989@infradead.org> <20090506090512.GB24692@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506090512.GB24692@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 11:05:12AM +0200, Ingo Molnar wrote:
> It might be more effective if you also wrote patches and if you 
> would shop for maintainer Acks, instead of just "pinging" people? 
> ;-) We've already got enough would-be-managers on lkml really.

I have no interest touching tons of architectures where the maintainers
are much better of looking at those lowlevel bits.  See the case where
Roland tried to do ARM but still hasn't gotten any feedback as a
negative example.

> Really, the above isnt a blocker list, it's your personal wish-list 
> for the future. Cleaning up ptrace itself is already an upstream 
> advantage worth having - for years ptrace was barely maintained. It 
> interfaces to enough critical projects (gdb, strace, UML, etc.) to 
> be a realiable (and testable) basis for utrace.

The cleanups aren't there for cleanup purposes, but to actually allow
the utrace-based ptrace being used unconditionally.  There is really
no point in merging a second conditional ptrace implementation that
has to be maintained while we add another one that doesn't add a single
new feature.

