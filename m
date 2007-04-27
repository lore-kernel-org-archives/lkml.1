Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbXD0WAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbXD0WAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbXD0WAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:00:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58865 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449AbXD0WAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:00:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 00:04:47 +0200
User-Agent: KMail/1.9.5
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704272324.43359.rjw@sisk.pl> <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704280004.47683.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 April 2007 23:44, Linus Torvalds wrote:
> 
> On Fri, 27 Apr 2007, Rafael J. Wysocki wrote:
> > 
> > Why do you think that keeping the user space frozen after 'snapshot' is a bad
> > idea?  I think that solves many of the problems you're discussing.
> 
> It makes it harder to debug (wouldn't it be *nice* to just ssh in, and do
> 
> 	gdb -p <snapshotter>
> 
> when something goes wrong?) but we also *depend* on user space for various 
> things (the same way we depend on kernel threads, and why it has been such 
> a total disaster to try to freeze the kernel threads too!).

We're freezing many of them just fine. ;-)

> For example, if you want to do graphical stuff, just using X would be quite
> nice, wouldn't it?

Yes, it would, but as long as we can't protect mounted filesystems from being
touched, it's just dangerous to let the user space run at that point.

> But I do agree that doing everythign in the kernel is likely to just be a 
> hell of a lot simpler for everybody.

:-)

Greetings,
Rafael
