Return-Path: <linux-kernel-owner+w=401wt.eu-S1751511AbYJSMrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbYJSMrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 08:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYJSMrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 08:47:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42142 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYJSMrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 08:47:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC] Kernel version numbering scheme change
Date: Sun, 19 Oct 2008 14:51:23 +0200
User-Agent: KMail/1.9.9
Cc: david@lang.hm, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081016002509.GA25868@kroah.com> <alpine.DEB.1.10.0810171821500.11079@asgard.lang.hm> <alpine.LRH.1.10.0810190108160.2000@twin.jikos.cz>
In-Reply-To: <alpine.LRH.1.10.0810190108160.2000@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810191451.24342.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 19 of October 2008, Jiri Kosina wrote:
> On Fri, 17 Oct 2008, david@lang.hm wrote:
> 
> > > Surely some scripts will start to break as soon as the third number gets
> > > three digits.
> > we've had three digit numbers in the third position before (2.3 and 2.5 
> > went well past three digits IIRC)
> 
> Did we? I only recall 2.5.7[something] and 2.3.5[something] (plus special 
> 2.3.99 release).
> 
> > > Actually, I thought we could continue to use a w.x.y.z numbering 
> > > scheme, but in such a way that:
> > > w = ($year - 2000) / 10 + 2 (so that we start from 2)
> > > x = $year % 10
> > > y = (number of major release in $year)
> > > z = (number of stable version for major release w.x.y)
> > > Then, the first major release in 2009 would be 2.9.1 and its first 
> > > -stable "child" would become 2.9.1.1.  In turn, the first major 
> > > release in 2010 could be 3.0.1 and so on.
> > if you want the part of the version number to increment based on the year,
> > just make it the year and don't complicate things.
> 
> In addition to that, having the kernel version dependent on year doesn't 
> really seem to make much sense to me. Simply said, I don't see any 
> relation of kernel source code contents to the current date in whatever 
> calendar system.
> 
> And 2.x+1.y-rcZ+1 immediately following 2.x.y-rcZ really hurts my eyes :)

Hm, why would that happen?

Rafael
