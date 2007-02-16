Return-Path: <linux-kernel-owner+w=401wt.eu-S1946279AbXBPWiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946279AbXBPWiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946280AbXBPWiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:38:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:39723 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946279AbXBPWiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:38:22 -0500
Subject: Re: [RFC] killing the NR_IRQS arrays.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20070216195256.GE2572@flint.arm.linux.org.uk>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	 <200702162045.58857.arnd@arndb.de>
	 <20070216195256.GE2572@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 09:37:05 +1100
Message-Id: <1171665426.5644.99.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Rather than having the job of rewriting this code during 2.6, I'd much
> > prefer to get something sorted, even if it is ARM only before 2.6.
> > 
> > I believe that there are some common problems with the existing API
> > which have been hinted at over the last few days, such as large
> > NR_IRQS.  As such, I think it would be a good idea to try to thrash
> > this issue out and get something which everyone is happy with.
> > 
> > Additionally, I've added Alan's "reserve then hook" idea to the API;
> > I seem to remember there is a case in IDE which needs something like
> > this.

You might want to have a look at the powerpc API with it's remaping
capabilities. It's very nice for handling multiple domain spaces. It
might be of some use for you.

I like your proposed API, I think that's where we want to go in the long
run.

Ben.


