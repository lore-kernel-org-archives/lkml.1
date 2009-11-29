Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbZK2JAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbZK2JAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 04:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZK2JAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 04:00:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41455 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZK2JAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 04:00:07 -0500
Date: Sun, 29 Nov 2009 09:59:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
Message-ID: <20091129085957.GF1530@ucw.cz>
References: <20091124200127.GA5751@redhat.com> <20091125214818.GA4916@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125214818.GA4916@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-11-25 16:48:18, Christoph Hellwig wrote:
> On Tue, Nov 24, 2009 at 09:01:27PM +0100, Oleg Nesterov wrote:
> > Hello.
> > 
> > This is the new iteration of Roland's utrace patch, this time
> > with "rewrite-ptrace-via-utrace" + cleanups in utrace core.
> > 
> > 1-7 are already in -mm tree, I am sending them to simplify the
> > review.
> > 
> > 8-12 don not change the behaviour, simple preparations.
> > 
> > 13-14 add utrace-ptrace and utrace
> 
> Skipped over it very, very briefly.  One thing I really hate about this
> is that it introduces two ptrace implementation by adding the new one
> without removing the old one.  Given that's it's pretty much too later
> for the 2.6.33 cycle anyway I'd suggest you make sure the remaining
> two major architectures (arm and mips) get converted, and if the
> remaining minor architectures don't manage to get their homework done
> they're left without ptrace.

I don't think introducing regressions to force people to rewrite code
is a good way to go...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
