Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbYCEVVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbYCEVVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761593AbYCEVVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:21:10 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60371 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbYCEVVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:21:08 -0500
Date: Wed, 5 Mar 2008 22:21:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc3: 34TB vmalloc total -- overflow in /proc/meminfo?
Message-ID: <20080305212139.GA31999@elf.ucw.cz>
References: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz> <alpine.DEB.1.00.0803052038410.8658@sheep.housecafe.de> <Pine.LNX.4.64.0803052045430.821@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803052045430.821@blonde.site>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > CommitLimit:   4132360 kB
> > > Committed_AS:    27684 kB
> > > VmallocTotal: 34359738367 kB
> > > VmallocUsed:     18112 kB
> > > VmallocChunk: 34359720115 kB
> 
> I don't see what Pavel's issue is with this: it's simply a fact that
> with a 64-bit kernel, we've lots of virtual address space to spare
> for vmalloc.  What would be surprising is for VmallocUsed to get up
> as high as that.

Hmm... ok, I see, I thought "clearly this overflowed somewhere", and I
was wrong, it is expected result.

Still.... what is 34TB of vmalloc space good for when we can only ever
allocate 4GB (because that is how much physical memory we have?)? To
prevent fragmentation? 

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
