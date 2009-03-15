Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbZCODyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbZCODyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 23:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZCODyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 23:54:14 -0400
Received: from phunq.net ([64.81.85.152]:48473 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753236AbZCODyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 23:54:13 -0400
From: Daniel Phillips <phillips@phunq.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Sat, 14 Mar 2009 20:54:09 -0700
User-Agent: KMail/1.9.9
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, tux3@tux3.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903121947.58367.nickpiggin@yahoo.com.au> <87eix2oeuu.fsf@devron.myhome.or.jp>
In-Reply-To: <87eix2oeuu.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903142054.09591.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, OGAWA Hirofumi wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> >> There are a couple of issues, one is u64 being (long) instead of
> >> (long long) as you say, and the other is variable type sizes like
> >> loff_t.  That specific one isn't actually a problem, we can just refuse
> >> to support 32 bit libc file ops, but there may be others.  We had a
> >> world of pain before (L) arrived, then with (L) it was easy.  Maybe
> >> just edit them all to (long long) for now, and damn the line length.
> >
> > Yes please do this. A significant style change like this that lots of
> > code already does I think is best first discussed as a standalone
> > change to kernel rather than everyone developing their own convention.
> 
> BTW, personally I wonder whether there are any suggestion - how early
> stage do we try to start review process? Someone suggests it should be
> early, but how early?
> 
> I know tux3 still have to work for various things, however, people join
> to develop those, and see the progress? Or people just want to see the
> result of various work later? ...

It is not just how quickly the work gets done, but the quality of work
that is more widely reviewed and has more total review cycles.  I guess
we are proceeding about the right speed in that direction: not slow,
not fast.  We won't be asking for merging immediately, just review.

There is a lot to be said for finishing up the most interesting
pre-merge bit, atomic commit, "in public", which of course we have done
all along, but it could be more public.  I would like to see a few more
folks get the "aha" about what we are doing with the cache model, the
hybrid logging and other details.

Regards,

Daniel
