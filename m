Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbYJQWpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbYJQWpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 18:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbYJQWo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 18:44:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37683 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbYJQWo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 18:44:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC] Kernel version numbering scheme change
Date: Sat, 18 Oct 2008 00:49:18 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Steven Noonan <steven@uplinklabs.net>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081016002509.GA25868@kroah.com> <20081017204723.15114eaa@lxorguk.ukuu.org.uk> <20081017214409.GB3585@kroah.com>
In-Reply-To: <20081017214409.GB3585@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810180049.19014.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 17 of October 2008, Greg KH wrote:
> On Fri, Oct 17, 2008 at 08:47:23PM +0100, Alan Cox wrote:
> > > And that's my point here, do we want to change the current numbering
> > > scheme as people have expressed annoyances of the current one.
> > 
> > But any new scheme will be just as annoying to someone and it messes up
> > existing documentation, understanding and risks breaking third party
> > tools.
> > 
> > Is it really worth the hassle, plus we'll have to change again if we use
> > date/times because once we are shipping Linux out to Alpha Centauri with
> > colonists there will be serious problems trying to compute the effect of
> > tau on release numbering ...
> 
> Sure, but by then, the 2.6.521 release will be out and we could fix it
> up by finally going to 3.0 :)

Surely some scripts will start to break as soon as the third number gets
three digits.

> Seriously, am I the only one that is getting annoyed by our version
> numbers?  If so, I can live with it, but I got the feeling that I wasn't
> alone here.

Actually, I thought we could continue to use a w.x.y.z numbering scheme, but
in such a way that:

w = ($year - 2000) / 10 + 2 (so that we start from 2)
x = $year % 10
y = (number of major release in $year)
z = (number of stable version for major release w.x.y)

Then, the first major release in 2009 would be 2.9.1 and its first -stable
"child" would become 2.9.1.1.  In turn, the first major release in 2010 could
be 3.0.1 and so on.

This seems to be close enough to the current numbering so that nothing should
really break.

Thanks,
Rafael
