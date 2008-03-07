Return-Path: <linux-kernel-owner+w=401wt.eu-S1762867AbYCGJE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762867AbYCGJE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYCGJDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:03:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59150 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbYCGJDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:03:52 -0500
Date: Fri, 7 Mar 2008 10:02:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080307090257.GC24047@elte.hu>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080306090029.GA6215@elte.hu> <20080306125929.GD17940@kernel.dk> <20080306130643.GB21359@elte.hu> <20080307085341.GA23814@elte.hu> <20080307085748.GM17940@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307085748.GM17940@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > no luck - a few hundred successful randconfig bootups overnight 
> > (with a rather complex userspace startup to full X plus networking, 
> > and the testbox is used via the network to compile the next random 
> > kernel as well - etc.) and no failure at all. So there's not much we 
> > can do at this point - i'll keep you updated if anything new happens 
> > in the tests.
> 
> OK, so it could possibly be something else or perhaps something that's 
> existed for a long time.
> 
> To capture vital debugging information for cases like this, I had an 
> idea for a sysrq key that would dump queue and io scheduler info for 
> all known block devices. That should help pin point where the problem 
> lies. If we have any letters left in the sysrq namespace :-)

btw., we should reserve one sysrq letter as a "meta" character. If that 
letter is 'X' [for Xtended SysRq] then SysRq-X SysRq-B could dump the 
block info.

	Ingo
