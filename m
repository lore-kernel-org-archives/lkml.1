Return-Path: <linux-kernel-owner+w=401wt.eu-S1761638AbZBEBIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638AbZBEBIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760379AbZBEBI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:08:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36137 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761042AbZBEBI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:08:26 -0500
Date: Thu, 5 Feb 2009 02:08:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bron Gondwana <brong@fastmail.fm>,
       Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Norbert Preining <preining@logic.at>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: Re: 2.6.29-rc3-git6: Reported regressions from 2.6.28
Message-ID: <20090205010811.GA5152@elte.hu>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain> <20090204181109.GR21085@gamma.logic.tuwien.ac.at> <alpine.LFD.2.00.0902041012440.3247@localhost.localdomain> <20090204185606.GA12991@elte.hu> <20090204222256.GA6954@brong.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204222256.GA6954@brong.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed Davide)

* Bron Gondwana <brong@fastmail.fm> wrote:

> On Wed, Feb 04, 2009 at 07:56:06PM +0100, Ingo Molnar wrote:
> >    [...] it is a natural reaction: 
> >    they only see the small trivial annoyance they intruduce themselves - 
> >    which is in a code area and usecase they are prominently familiar with, 
> >    so they cannot personally relate to the trouble that users go through if 
> >    they hit such issues.
> 
> Amen.  Preach it.  I spent quite a while just a week ago arguing that 
> every semi-loaded machine out there using epoll should not require the 
> admin to discover that their previously happy software stack was suddenly 
> hitting an artificially tiny per-user instances count.
> 
> Luckily I was able to find multiple blog posts and mailing list archives 
> with people who had literally spent _days_ tracking down why things had 
> broken for them when they upgraded to a new -stable kernel.
> 
> You really do have to assume that your users don't have time for this 
> shit.  Anything that really can't DTRT automatically needs to be covered 
> with plenty of easy to follow instructions on how to fix the problem - 
> because for someone unfamiliar with that area of the system it really does 
> take enormous effort to track down what's changed.

do you know which commit that was (or which exact tunable default value it 
is about) and whether we could restore the old default safely, and whether 
there's some reasonable minium must-have value that still works well in 
practice?

With Moore's law still alive and kicking there's normally no reason to 
narrow defaults - if then they get increased or get changed to some 
auto-size-to-hw-capabilities dynamic method.

Upstream defaults usually get narrowed only for really good reasons and 
often the reason is DoS and security and a specific testcase that kills a 
default box with a too large default. Sometimes they get narrowed spuriously 
and then we can fix things reasonably.

	Ingo
