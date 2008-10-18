Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbYJRXPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbYJRXPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 19:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbYJRXPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 19:15:24 -0400
Received: from twin.jikos.cz ([213.151.79.26]:54552 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbYJRXPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 19:15:21 -0400
Date: Sun, 19 Oct 2008 01:14:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: david@lang.hm
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <alpine.DEB.1.10.0810171821500.11079@asgard.lang.hm>
Message-ID: <alpine.LRH.1.10.0810190108160.2000@twin.jikos.cz>
References: <20081016002509.GA25868@kroah.com> <20081017204723.15114eaa@lxorguk.ukuu.org.uk> <20081017214409.GB3585@kroah.com> <200810180049.19014.rjw@sisk.pl> <alpine.DEB.1.10.0810171821500.11079@asgard.lang.hm>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, david@lang.hm wrote:

> > Surely some scripts will start to break as soon as the third number gets
> > three digits.
> we've had three digit numbers in the third position before (2.3 and 2.5 
> went well past three digits IIRC)

Did we? I only recall 2.5.7[something] and 2.3.5[something] (plus special 
2.3.99 release).

> > Actually, I thought we could continue to use a w.x.y.z numbering 
> > scheme, but in such a way that:
> > w = ($year - 2000) / 10 + 2 (so that we start from 2)
> > x = $year % 10
> > y = (number of major release in $year)
> > z = (number of stable version for major release w.x.y)
> > Then, the first major release in 2009 would be 2.9.1 and its first 
> > -stable "child" would become 2.9.1.1.  In turn, the first major 
> > release in 2010 could be 3.0.1 and so on.
> if you want the part of the version number to increment based on the year,
> just make it the year and don't complicate things.

In addition to that, having the kernel version dependent on year doesn't 
really seem to make much sense to me. Simply said, I don't see any 
relation of kernel source code contents to the current date in whatever 
calendar system.

And 2.x+1.y-rcZ+1 immediately following 2.x.y-rcZ really hurts my eyes :)

-- 
Jiri Kosina
SUSE Labs

