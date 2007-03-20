Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbXCTSJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbXCTSJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXCTSJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:09:07 -0400
Received: from [212.12.190.160] ([212.12.190.160]:33222 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751972AbXCTSJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:09:05 -0400
From: Al Boldi <a1426z@gawab.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RSDL v0.31
Date: Tue, 20 Mar 2007 21:08:26 +0300
User-Agent: KMail/1.5
Cc: Willy Tarreau <w@1wt.eu>, Xavier Bestel <xavier.bestel@free.fr>,
       Mark Lord <lkml@rtr.ca>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703042335.26785.a1426z@gawab.com> <20070320061152.GW943@1wt.eu> <Pine.LNX.4.64.0703200821420.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703200821420.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200703202108.26122.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I was very happy to see the "try this patch" email from Al Boldi - not
> because I think that patch per se was necessarily the right fix (I have no
> idea), 

Well, it wasn't really meant as a fix, but rather to point out that 
interactivity boosting is possible with RSDL.

It probably needs a lot more work, but just this one-liner gives an 
unbelievable ia boost.

> but simply because I think that's the kind of mindset we need to have.

Thanks.

> Not a lot of people really *like* the old scheduler, but it's been tweaked
> over the years to try to avoid some nasty behaviour. I'm really hoping
> that RSDL would be a lot better (and by all accounts it has the potential
> for that), but I think it's totally naïve to expect that it won't need
> some tweaking too.

Aside from ia boosting, I think fixed latencies per nice levels may be 
desirable, when physically possible, to allow for more deterministic 
scheduling.

> So I'll happily still merge RSDL right after 2.6.21 (and it won't even be
> a config option - if we want to make it good, we need to make sure
> *everybody* tests it), but what I want to see is that "can do" spirit wrt
> tweaking for issues that come up.
>
> Because let's face it - nothing is ever perfect. Even a really nice
> conceptual idea always ends up hitting the "but in real life, things are
> ugly and complex, and we've depended on behaviour X in the past and can't
> change it, so we need some tweaking for problem Y".
>
> And everything is totally fixable - at least as long as people are willing
> to!

Agreed.


Thanks!

--
Al

