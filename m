Return-Path: <linux-kernel-owner+w=401wt.eu-S1762579AbZCaQZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762579AbZCaQZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761133AbZCaQZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:25:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56717 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbZCaQZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:25:29 -0400
Date: Tue, 31 Mar 2009 12:25:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       oleg@redhat.com, adobriyan@gmail.com, mingo@elte.hu,
       torvalds@linux-foundation.org, fche@redhat.com, roland@redhat.com,
       rostedt@goodmis.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Christoph Hellwig <hch@infradead.org>, Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090331162504.GA28442@infradead.org>
References: <20090321154501.GA2707@elte.hu> <20090321143413.75ead1aa.akpm@linux-foundation.org> <20090321215145.GB5262@redhat.com> <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain> <20090322123749.GF19826@elte.hu> <20090323134813.GA18219@x200.localdomain> <20090323151400.GA3413@redhat.com> <20090323214417.GD5814@mit.edu> <20090330151844.8b4eed0f.akpm@linux-foundation.org> <1238491062.28248.2046.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238491062.28248.2046.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 11:17:42AM +0200, Peter Zijlstra wrote:
> > Could those who object to utrace please pipe up and summarise their
> > reasons?
> 
> Christoph used to have an opinion on this matter, so I've added him to
> the CC.

I've never objected utrace per see, quite contrary I think it's a useful
abstraction.  I did have objection over various implementation details
which should be sorted out now (have to take a look again to make sure).

I do have a really large objection of merging the current messy double
ptrace implementation.  If current utrace based ptrace isn't 100% ready
there's absolutely no point in merging it.  Other user would be even
better, e.g. the seccomp rewrite.

