Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbZGXPlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbZGXPlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbZGXPlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:41:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48338 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752672AbZGXPlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:41:08 -0400
Date: Fri, 24 Jul 2009 16:40:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ray Lee <ray-lk@madrabbit.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression] kdesu broken
Message-ID: <20090724164058.21a054e6@lxorguk.ukuu.org.uk>
In-Reply-To: <200907241721.45943.rjw@sisk.pl>
References: <200907240145.31935.rjw@sisk.pl>
	<2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
	<200907241721.45943.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 17:21:45 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Friday 24 July 2009, Ray Lee wrote:
> > On Thu, Jul 23, 2009 at 4:45 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > > A recent kernel change broke kdesu (from KDE 4.2) on my test boxes.  ISTR a
> > > discussion about that, but I can't find it right now.  Any clues?
> > 
> > See the thread starting here: ("possible regression with pty.c commit")
> >    http://lkml.org/lkml/2009/7/11/125
> 
> Thanks for the pointer.
> 
> Well, I thought we were expected to avoid breaking existing user space, even
> if that were buggy etc.

I don't know where you got that idea from. Avoiding breaking user space
unneccessarily is good but if its buggy you often can't do anything about
it.

Alan
