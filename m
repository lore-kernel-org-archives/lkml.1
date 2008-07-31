Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbYHAAEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbYHAAEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 20:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbYHAAEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 20:04:45 -0400
Received: from 216-237-85-90-client.sopris.net ([216.237.85.90]:47362 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751580AbYHAAEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 20:04:44 -0400
X-Greylist: delayed 1155 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2008 20:04:43 EDT
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Amanda McPherson <amanda@amcpherson.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] A development process document
References: <20080729143015.0f79cf37@bike.lwn.net>
From: Jake Edge <jake@lwn.net>
Date: Thu, 31 Jul 2008 17:45:15 -0600
In-Reply-To: <20080729143015.0f79cf37@bike.lwn.net> (Jonathan Corbet's message of "Tue\, 29 Jul 2008 14\:30\:15 -0600")
Message-ID: <m3wsj1ipo4.fsf@lwn.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jon,

A few minor things I found:

Jonathan Corbet <corbet@lwn.net> writes:

> +in existence.  Since its humble beginning in 1991, this kernel has evolved
> +into a best-of-breed operating system component which runs on pocket-sized
> +digital music players, desktop PCs, the largest supercomputers in
> +existence, and all types of system in between.  It is a robust, efficient,

systems

> +- Binary modules greatly increase the difficulty of debugging kernel
> +  problems, to the point that most kernel developers will not even try.  So
> +  the distribution of binary-only modules will make support harder for
> +  those who use them.

The last sentence reads a little funny to me, maybe something like:

By distributing binary-only modules, you make it harder for you and your 
users to get support.

> +kernel under the GPL.  Code which has not been licensed as free software by
> +its owner, or which risks creating copyright-related problems for the
> +kernel (such as code which derives from improper reverse-engineering
> +efforts) cannot be contributed.

To me, this sort of implies that all reverse-engineering is improper, which
is not what you meant to say, I don't think.

> +A relatively straightforward discipline is followed with regard to the
> +merging of patches for each release.  At the beginning of each development
> +cycle, the "merge window" is said to be open.  At this time, code which is

"At this time" sounds like you are saying "now", "At that time" perhaps?
(maybe too picky)

> + - Early review.  Patches are posted to the relevant mailing list, and
> +   developers on that list reply with any comments they may have.  This
> +   process should turn up any major problems with a patch, if all goes
> +   well.

The comma after "patch" seems confusing.

> +When the merge window opens, top-level maintainers will ask Linus to "pull"
> +the patches they have selected for merging from their repositories.  If
> +Linus agrees, the stream of patches will flow up into his repository,
> +becoming part of the mainline kernel.  The amount of attention that Linus
> +pays to specific patches received in a pull operation varies.  It is clear
> +that, sometimes, he looks quite closely.  But, as a general, Linus trusts
> +the subsystem maintainers to not send bad patches upstream.

do you mean that Linus is a general?  or should that be "general rule"?  It
could work either way.

> +degree of politeness.  But there is no other place where the kernel
> +development community comes together as a whole; developers will avoid this
> +list at the risk of missing important information.

the last clause sounds like developers *will* avoid the list, maybe:
developers who avoid this list risk missing important information

> +patches.  Those are the people who be best placed to help with a new
> +development project.

"who be best placed"?  who will be best placed ...

> +One of the heavier debugging tools is the locking checker, or "lockdep."

should lockdep have a period?

> +how many people will build your code into their kernels.  And, of course,
> +where there's testers, there's bug reports.

where there are testers, there are bug reports.

> +development history.  An inconvenient patch (one which breaks bisection,
> +say, or which has some other sort of obvious bug) can be fixed in place or
> +make to disappear from the history entirely.  A patch series can be

be made to disappear

> +read.  Many internal kernel APIs are documented using the kerneldoc
> +mechanism; "make htmldocs" or "make pdfdocs" can be used to generate those
> +documents in HTML or PDF format (though the version of TeX shipped by some
> +distributions run into internal limits and fails to process the documents
> +properly).

"run into internal limits"?  but, "runs into internal limits" doesn't seem
quite right either. 

hope that helps,

jake

-- 
Jake Edge - jake@lwn.net - http://lwn.net
