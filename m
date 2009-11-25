Return-Path: <linux-kernel-owner+w=401wt.eu-S935088AbZKYVs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935088AbZKYVs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932970AbZKYVsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:48:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39581 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935AbZKYVsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:48:24 -0500
Date: Wed, 25 Nov 2009 16:48:18 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
Message-ID: <20091125214818.GA4916@infradead.org>
References: <20091124200127.GA5751@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124200127.GA5751@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 09:01:27PM +0100, Oleg Nesterov wrote:
> Hello.
> 
> This is the new iteration of Roland's utrace patch, this time
> with "rewrite-ptrace-via-utrace" + cleanups in utrace core.
> 
> 1-7 are already in -mm tree, I am sending them to simplify the
> review.
> 
> 8-12 don not change the behaviour, simple preparations.
> 
> 13-14 add utrace-ptrace and utrace

Skipped over it very, very briefly.  One thing I really hate about this
is that it introduces two ptrace implementation by adding the new one
without removing the old one.  Given that's it's pretty much too later
for the 2.6.33 cycle anyway I'd suggest you make sure the remaining
two major architectures (arm and mips) get converted, and if the
remaining minor architectures don't manage to get their homework done
they're left without ptrace.

The other thing is that this patchset really doesn't quite justify
utrace.  It's growing a lot more code without actually growing any
useful functionality.  What about all those other utrace killer
features that have been promised for a long time?

