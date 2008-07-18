Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbYGRPuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbYGRPuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYGRPty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:49:54 -0400
Received: from pond.fysh.org ([166.84.7.109]:52248 "EHLO pond.fysh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbYGRPtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:49:53 -0400
X-Greylist: delayed 1495 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2008 11:49:53 EDT
Date: Fri, 18 Jul 2008 16:24:56 +0100
From: Athanasius <link@miggy.org>
To: david@lang.hm, linux-kernel <linux-kernel@vger.kernel.org>
Cc: el es <el_es_cr@yahoo.co.uk>
Subject: Re: Kernel version : what about YYYY.MM.[01].x ?
Message-ID: <20080718152456.GA27729@miggy.org>
Mail-Followup-To: david@lang.hm,
	linux-kernel <linux-kernel@vger.kernel.org>,
	el es <el_es_cr@yahoo.co.uk>
References: <loom.20080717T083755-676@post.gmane.org> <alpine.DEB.1.10.0807171558450.17859@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807171558450.17859@asgard.lang.hm>
X-gpg-fingerprint: E218CE1D
X-gpg-key: http://www.fysh.org/~athan/gpg-key
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  In reading this thread I've seen folk come up with some good
suggestions, and some bad ones.  I think I can sum things up as follows:

1) Need to clearly designate
        a) A fresh stable release
        b) Also updates to that stable release, without getting confused
           with any development releases.
        c) A fresh development release/pre-release of next stable, without
           getting confused with current stable releases.

2) The only real objection to the status quo seems to be "the 3rd number
is getting too big".  This is highly subjective and not a good enough
reason by itself to change the scheme.

3) It would be nice for stable releases to encode when their initial
version was made.  This gives extra information in the version number
without having to do a lookup.  The problem with this is you don't know
when the next stable release will actually be.  This means you can't
base your development version numbering on that, i.e. no simply
appending -rcX to something as you don't know what the something should
be.
  But -rcX is just one way of doing it, all we really need is for it to
be clear if a version is part of development or part of a stable
release.

I therefore propose the form YYYY.MM.[sd].x

So, 2.6.26 would have been 2008.07.s.0

The first update to it would be 2008.07.s.1

The development code would continue now as 2008.07.d.0 and onwards
incrementing the last number as development progresses.

Some might object to the user of [sd] on grounds of easy sorting.  In
which case just use 0 for stable and 1 for development.  Yes, this means
going back to the odd/even designation we had pre-2.6, but as we also
stick to the relatively short development cycle it really doesn't
matter.  Also with the base being YYYY.MM we'll only ever use 0 and 1
anyway.

So, YYYY.MM.[0|1].x gives us:

        1) Clear indication of when this stable series started.
        2) Clear indication of updates to that stable version.
        3) Clear designation of the development versions started after
        that stable release.

Note however what I said in my 2nd point.  The only *real* objection to
the current scheme is 'big numbers', and that's subjective.  I only find
it worth making a proposal due to the reasoning in my 3rd point, i.e. it
IS a good idea to encode *when* a stable release was made in its version
number.  This not only allows someone to see how long the current
development cycle has been going (to within +/- 4 weeks), but also
allows a glance at all prior versions to show how quickly development
progresses on average between stable versions.
-- 
- Athanasius = Athanasius(at)miggy.org / http://www.miggy.org/
                  Finger athan(at)fysh.org for PGP key
	   "And it's me who is my enemy. Me who beats me up.
Me who makes the monsters. Me who strips my confidence." Paula Cole - ME
