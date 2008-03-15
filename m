Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYCOVZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYCOVZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYCOVYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:24:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43603 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752069AbYCOVYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:24:52 -0400
Date: Sat, 15 Mar 2008 21:03:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: Willy Tarreau <w@1wt.eu>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080315210308.72824eb3@the-village.bc.nu>
In-Reply-To: <200803151417.13899.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<200803131214.40321.phillips@phunq.net>
	<20080315205950.GA13012@1wt.eu>
	<200803151417.13899.phillips@phunq.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > RAID controllers do not have half a terabyte of RAM.
> 
> And?  Either you have battery backed ram with critical data in it or
> you do not.  Exactly how much makes little difference to the question.

It makes a lot of difference, and in addition raid controllers (good
ones) respect barrier ordering in their RAM cache so they'll take tags or
similar interfaces and honour them.

> That is why I keep recommending that a ramback setup be replicated or
> mirrored, which people in this thread keep glossing over.  When
> replicated or mirrored, you still get the microsecond-level transaction
> times, and you get the safety too.

Either you keep a mirror in sync and get normal data rates or you keep
the mirror out of sync and then you need to sort your writeback process
out to preserve ordering.

If you want ramback to be taken seriously then that is the interesting
problem to solve and clearly has multiple solutions if you would start to
take an objective look at your work.

