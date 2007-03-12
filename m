Return-Path: <linux-kernel-owner+w=401wt.eu-S1750895AbXCLSKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895AbXCLSKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXCLSKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:10:30 -0400
Received: from mail04.syd.optusnet.com.au ([211.29.132.185]:58621 "EHLO
	mail04.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbXCLSK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:10:29 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Tue, 13 Mar 2007 05:09:45 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <200703122223.07048.kernel@kolivas.org> <20070312134806.GE4372@thunk.org>
In-Reply-To: <20070312134806.GE4372@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703130509.45405.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 00:48, Theodore Tso wrote:
> On Mon, Mar 12, 2007 at 10:23:06PM +1100, Con Kolivas wrote:
> > > > > We are getting good interactive response with a fair scheduler yet
> > > > > you seem intent on overloading it to find fault with it.
> > > >
> > > > I'm not trying to find fault, I'm TESTING AND REPORTING.  Was.
> > >
> > > Con, could you please take Mike's report of this regression seriously
> > > and address it? Thanks,
> >
> > Sure.
> >
> > Mike the cpu is being proportioned out perfectly according to fairness as
> > I mentioned in the prior email, yet X is getting the lower latency
> > scheduling. I'm not sure within the bounds of fairness what more would
> > you have happen to your liking with this test case?
>
> Con,
>
> 	I think what we're discovering is that a "fair scheduler" is
> not going to cut it.  After all, running X and ripping CD's and MP3
> encoding them is not exactly an esoteric use case.  And like it or
> not, "nice" defaults to 4.
>
> 	I suspect Mike is right; the only way to deal with this
> regression is some scheduler hints from the desktop subsystem (i.e., X
> and friends).  Yes, X is broken, it's horrible, yadda, yadda, yadda.
> It's also what everyone is using, and it's a fact of life.  Just like
> we occasionally have had to work around ISA braindamage, and x86
> architecture braindamage, and ACPI braindamage all inflicted on us by
> Intel.  This is just life, and sometimes the clean, elegant solution
> is not enough.

Instead of assuming it's bad, have you tried RSDL for yourself? Mike is using 
2 lame threads for his test case.

-- 
-ck
