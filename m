Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbYBISLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbYBISLf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 13:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYBISL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 13:11:26 -0500
Received: from qb-out-0506.google.com ([72.14.204.234]:26532 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbYBISLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 13:11:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=M8SvZIwBM6glg2CT3ouK5r4UWKd2lq4e+FeCcNxYJAuqYmbcUf6ZVbJiC3EDlVcbm5poDuSlxtr2ekBmg1KcJ0vDCp0u/z3qmWQcFXDtkqEP0LQCyILqnDNow9nPsHDuc6CgP6cfMdkmLedy7ccmsvv51d/SW0FCNhCn7GhvVb0=
Message-ID: <2f11576a0802091011r61da1d67q3b7b114f495d780a@mail.gmail.com>
Date: Sun, 10 Feb 2008 03:11:22 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH 2.6.24-mm1] Mempolicy: silently restrict nodemask to allowed nodes V3
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <clameter@sgi.com>, "Paul Jackson" <pj@sgi.com>,
       "David Rientjes" <rientjes@google.com>, "Mel Gorman" <mel@csn.ul.ie>,
       linux-mm <linux-mm@kvack.org>, torvalds@linux-foundation.org,
       "Eric Whitney" <eric.whitney@hp.com>
In-Reply-To: <1202499913.5346.60.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1202149243.5028.61.camel@localhost>
	 <20080205163406.270B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1202499913.5346.60.camel@localhost>
X-Google-Sender-Auth: e8a0c04c6d419e2d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee-san

looks good for me.
I'll test about the head of week and report it by another mail.

Thanks!

> Was "Re: [2.6.24 regression][BUGFIX] numactl --interleave=all doesn't
> works on memoryless node."
>
> [Aside:  I noticed there were two slightly different distributions for
> this topic.  I've unified the distribution lists w/o dropping anyone, I
> think.  Apologies if you'd rather have been dropped...]
>
> Here's V3 of the patch, accomodating Kosaki Motohiro's suggestion for
> folding contextualize_policy() into mpol_check_policy() [because my
> "was_empty" argument "was ugly" ;-)].  It does seem to clean up the
> code.
