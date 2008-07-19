Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbYGSVRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbYGSVRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 17:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYGSVRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 17:17:10 -0400
Received: from vapor.isi.edu ([128.9.64.64]:43648 "EHLO vapor.isi.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbYGSVRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 17:17:09 -0400
Date: Sat, 19 Jul 2008 14:16:53 -0700
From: Craig Milo Rogers <rogers@ISI.EDU>
To: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Cc: linux-kernel@vger.kernel.org
Subject: Re: From 2.4 to 2.6 to 2.7?
Message-ID: <20080719211653.GF18350@isi.edu>
References: <20080719080002.GA11272@isi.edu> <200807191930.m6JJURC12038@inv.it.uc3m.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807191930.m6JJURC12038@inv.it.uc3m.es>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ISI-4-43-8-MailScanner: Found to be clean
X-MailScanner-From: rogers@jib.isi.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.07.19, Peter T. Breuer wrote:
> In article <20080719080002.GA11272@isi.edu> you wrote:
> > In <200807180823.m6I8NIo27365@inv.it.uc3m.es>, Peter T. Breuer
> > proposed switching to a three-level numbering scheme and resetting the
> > middle number when useful [which I suppose might mean a major feature
> > change or just a desire to avoid largish meaningless numbers].  I
> > assume this sould give a sequence like:
> 
> > 2.6.26.s, 2.8.s, 2.9.s, 2.10.s,
> 
> Actually he said
> 
>    rename 2.6.28 to 2.8.0
> or 
>    rename 2.6.29 to 2.9.0
> or
>    rename 2.6.30 to 3.0.0
> 
> i.e. .. whatever you are doing now, just drop the first two numbers (the
> "2.6" bit) since they seem to be constant.

	So you're saying that the formula is to drop the "2.6" and place
a period between the first and sedond digits of what's currently the
release number? OK, I hadn't interpreted it that way.  Does the sequence
continue like this?

... 9.9.0, 10.0.0, ...

> Remember that Linus' only objective is to have smaller numbers, which
> may therefore
> 
>  1) be memorable
>  2) be good advertising copy
>  3) be meaningful
> 
> and that was the only intention of my scheme: "drop the constant bit".

	And the underlying problem is that there are only so many
small numbers.  Eventually, inevitably, constant bits accumulate in
front of the changing bits.

	Given the three criteria shown above, Linus' proposed scheme:

yyyy.r.s

seems best to me.  We know the year, it relates directly to common
experience and effectively is a small number (this year, last year,
two years ago... 0, 1, 2 years ago).

	There's the potential for cognitive dissonance if the linux
kernel takes a yyy.x format and the distrbutions also use yyyy.x, but
the two aren't the same?  e.g., what will people think if, say,
openSUSE 2009.2 contains linux kernel 2009.1?  Perhaps the
distibutions would synchronize to kernel releases as a consequence of
a revised kernel naming convention?

	There's the question of what to do if you plan on a end-of year
release, and it just doesn't happen.  I see three strategies, some of
which have been mentioned already in this thread:

1)	Retain the "yyyy.r" part, even though it's year yyyy+1 before the
	stable relese is issued.

	2008.3.rc5, 2008.3.rc6, [year 2009 arrives], 2008.3.rc7, 2008.3.0

2)	Drop  the "yyyy.r" and start over with rc1 for "yyyy+1.1".

	2008.3.rc5, 2008.3.rc6, [year 2009 arrives], 2009.1.rc1, 2009.1.0

3)	Drop  the "yyyy.r" in favor of "yyyy+1.1", but don't break the
	rc# numbering:

	2008.3.rc5, 2008.3.rc6, [year 2009 arrives], 2009.1.rc7, 2009.1.0


	The last varient seems strange on the surface, but I think it
would be easier in practice, because developers could refer to "rc5",
"rc6", "rc7", dropping the locally-constant bits will less potential
ambiguity than if the "rc#" sequence was interrupted.

					Craig Milo Rogers


