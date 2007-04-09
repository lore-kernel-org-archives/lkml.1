Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbXDIIYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbXDIIYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 04:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbXDIIYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 04:24:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:58867 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751555AbXDIIYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 04:24:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19WWnV75shWBsW1vW6o+W1n5nttB/Me00Uy3H5Htq
	vVYNZA26b92mJg
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200704090116.37329.gene.heskett@gmail.com>
References: <200703290237.38777.kernel@kolivas.org>
	 <200704081356.48843.gene.heskett@gmail.com>
	 <1176092271.6355.16.camel@Homer.simpson.net>
	 <200704090116.37329.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 10:24:40 +0200
Message-Id: <1176107081.9909.17.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 01:16 -0400, Gene Heskett wrote:
> On Monday 09 April 2007, Mike Galbraith wrote:
> >
> >So tar -cvf - / | gzip --best | tar -tvzf - should reproduce the
> >problem?
> >
> That looks as if it should demo it pretty well if I understand correctly 
> everything you're doing there.

Ok, I can't reproduce any bad interactivity here with that workload
either with SMP or UP kernel.  That said however, gzip does attain
interactive status, which it really should not - that gives it an unfair
advantage over it's peers.

With my throttled tree, it gets pushed back down to where it belongs.
I'm going to try to tighten the tolerance on behavior to evict the
riffraff who don't really belong in the elite interactive club sooner,
and guarantee that even fast/light tasks can't dominate the CPU without
paying heavily.

(to close the many fast/light tasks wakeup scenario that the "untested"
patch someone mentioned did, but was shown to be too painful to bare).

	-Mike

