Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYGCL6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYGCL6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 07:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYGCL4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 07:56:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbYGCL4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 07:56:11 -0400
Date: Thu, 3 Jul 2008 02:01:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: David Brownell <david-b@pacbell.net>, Michael Buesch <mb@bu3sch.de>,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] gpiolib: Allow user-selection
Message-Id: <20080703020106.fec84f0f.akpm@linux-foundation.org>
In-Reply-To: <486C8F9C.7080507@keyaccess.nl>
References: <200807022346.53222.mb@bu3sch.de>
	<20080702170431.56d4c929.akpm@linux-foundation.org>
	<200807022200.49428.david-b@pacbell.net>
	<20080702220842.44364045.akpm@linux-foundation.org>
	<486C8F9C.7080507@keyaccess.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jul 2008 10:36:44 +0200 Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 03-07-08 07:08, Andrew Morton wrote:
> 
> > But what I am repeatedly seeing is people cheerfully raising 2.6.27 
> > patches against the 2.6.26 tree when we have a nice 2.6.27 tree for 
> > developing against.  Those days are over, guys.
> > 
> > I'm also seeing obvious signs that developers aren't _testing_ their 
> > new code within the context of the 2.6.27 tree.  They're obviously 
> > testing their stuff against 2.6.26 and then hoping and praying, only
> > it doesn't always work out for them.
> 
> Developing against -next is even worse than developping against an -rc1. 
> You normally want to be running the code you develop meaning you'd very 
> frequently drown in everyone else's bugs without getting to your own if 
> you do.

Stuff happens.  linux-next is generally OKish.

> Development needs to happen against something relatively stable 
> really and the last release would generally seem to be the best choice.

Well one can develop against mainline and port to linux-next and then
do a quick test.  But it seems like pointless additional overhead to
me.

What else can we do?  People are frequently sending patches which don't
even apply to the tree for which they're intended.  And some which
simply fail at compile-time or runtime when they are applied to that tree.

> Now ofcourse, _porting_ it to -next before submitting makes lots of 
> sense but positioning -next as THE devel tree a bit less I feel...

If one wishes.

It's readily obvious that people (ie: top-level maintainers) aren't
even compile-testing their own stuff once it's merged into linux-next. 
You say (but don't provide evidence that) linux-next is too unstable to
develop against.  Well guess why?  Because people are choosing to let
it be that way.


Now the upshot of this might be that people end up having to spend more
time testing and less time developing.  It is fairly apparent that this
is a desirable outcome.
