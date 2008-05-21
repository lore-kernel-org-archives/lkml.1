Return-Path: <linux-kernel-owner+w=401wt.eu-S937122AbYEUTqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937122AbYEUTqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937069AbYEUTpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:45:51 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:57509 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937067AbYEUTpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:45:49 -0400
Date: Wed, 21 May 2008 15:45:36 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard
	indentation of arguments)
Message-ID: <20080521194536.GM8581@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
	davem@davemloft.net
References: <12113495282137-git-send-email-kongjianjun@gmail.com> <20080521083413.GM28946@ZenIV.linux.org.uk> <20080521015037.add0b78e.akpm@linux-foundation.org> <20080521094153.GN28946@ZenIV.linux.org.uk> <20080521104418.736e3379.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521104418.736e3379.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 10:44:18AM -0700, Andrew Morton wrote:
> I have spoken with engineers both individual and within companies who
> have developed and who plan to develop substantial kernel features. 
> I'm forever explaining to people why they should work to get that code
> merged up.  One reason for their not yet having done so which comes up
> again and again is apprehension at the reception they will receive.  In
> public.  This problem appears to be especially strong in Asian
> countries.  You have just made the situation worse.

It probably did make things marginally worse from that standpoint, but
the code style weanies also make things worse, so at least IMHO it's a
wash.

I'd suggest that the more aggressive public code reviews and the
perception that it is highly painful, time-consuming, and expensive to
get code merged up.  But of course we need that to maintain quality.
Even if we eliminated all code style weanies slapdowns, if a Asian
Engineer submits a patchset, and it gets (rightly) ripped to pieces by
Cristoph for all sorts of code quality problems, and by Al Viro
because it intrdoces tons and tons of deadlocks, we'll still have the
potential problem that the Asian engineer feels that he has shamed his
company and has to resign or will get fired by his management.  

The only way to solve that problem is either to change the perception
of Asian engineers and at their companies (and there has been some
success along that line that what is being attacked is the code, not
the submitter), and we could meet them halfway by offering to do an
initial code reivew privately so they don't have to feel that they are
getting publically humiliated.  (And there is a little of that going
on, informally, as well.)

So yes, it's a problem, and I'd agree if this was an gratuitously mean
code review.  i.e., the difference between, "isn't this a locking
hierarchy violation?" vs "Congratulations!  You've just completely
screwed up VM locking hierarchy, you idiot!".

People have been a bit frustrated by the stupid patches and people who
waste time with whitespace patches or running checkpatch.pl on random
files, so it's a bit understandable that they might slap down those
folks --- and I would hope that one of these Asian engineers would be
able to see the difference between a desperately needed slapdown and
the reception they might get when they submit a patch to be merged up.
(But if they are getting their patches ripped apart during the code
review, and that's causing them to lose face inside their company,
that's a different problem.)

					- Ted
	      	      		 
