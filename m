Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZK0OEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZK0OEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZK0OEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:04:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33974 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZK0OEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 09:04:41 -0500
Date: Fri, 27 Nov 2009 09:04:39 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
Message-ID: <20091127140439.GA17000@infradead.org>
References: <20091124200127.GA5751@redhat.com> <20091125214818.GA4916@infradead.org> <20091126091052.GF1389@elte.hu> <20091126104722.GA8316@infradead.org> <20091126122441.GC15189@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126122441.GC15189@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 01:24:41PM +0100, Ingo Molnar wrote:
> FYI, the merge window has not opened yet, so it cannot close in a few 
> days.

subsystems merged window, not Linus'.

> 
> > [...] and thus not getting any of the broad -next test coverage is a 
> > pretty bad idea.  In the end it will be the maintainers ruling but 
> > that doesn't make it a good idea from the engineering point of view.
> 
> FYI, it's been in -mm, that's where it's maintained.

None of the recent mm snapshots has anything utrace related in there,
just a few ptrace patches from Oleg (which are in this series but a very
small part of it) and certainly not all this new code that is pretty
recent (take a look at the utrace list for the development).

> Yes. Which is a further argument to not do it like that but to do one 
> arch at a time. Trying to do too much at once is bad engineering.

I'm not sure why you're trying to pick fights here, but no one has said
about doing it all in once.  The point I'm trying to make is that it's
pretty bad to keep parallel ptrace implementations, and we should settle
on one.  A pre-requisite of using the new once genericly is to have the
architecture ptrace code updated.  I think arm and mips are the two
only relevant ones still missing, so updating them and killing the other
ones is easy.

If you think keeping the two ptrace implementations is fine argue for
that directly, but please stick to the technical points instead of just
fighting for fightings sake.
