Return-Path: <linux-kernel-owner+w=401wt.eu-S1763469AbYBEXir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763469AbYBEXir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763329AbYBEXii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:38:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763321AbYBEXig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:38:36 -0500
Date: Tue, 5 Feb 2008 15:37:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: adobriyan@sw.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Whine about suspicious return values from module's
 ->init() hook
Message-Id: <20080205153752.243d3b63.akpm@linux-foundation.org>
In-Reply-To: <200802060948.11133.rusty@rustcorp.com.au>
References: <20080204154215.GA26618@localhost.sw.ru>
	<200802051708.37349.rusty@rustcorp.com.au>
	<20080204222457.286b962f.akpm@linux-foundation.org>
	<200802060948.11133.rusty@rustcorp.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 09:48:10 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tuesday 05 February 2008 17:24:57 Andrew Morton wrote:
> > On Tue, 5 Feb 2008 17:08:37 +1100 Rusty Russell <rusty@rustcorp.com.au> 
> wrote:
> > > On Tuesday 05 February 2008 14:53:18 Andrew Morton wrote:
> > > > That risks killing previously-working setups.  WARN_ON is sufficient.
> > >
> > > I disagree.  WARN_ON is useful for developers, but they can handle
> > > BUG_ON, too.
> >
> > For developers, BUG_ON has zero benefit relative to WARN_ON.
> >
> > For non-developers, BUG_ON has large disadvantages relative to WARN_ON.
> >
> > It's a no-brainer.
> 
> For non-developers, WARN_ON is a noop.

Oh..  Rusty.  The mailing list and bugzilla are *full* of WARN_ON reports
from testers.  Your statement is empirically wrong.

> For developers, WARN_ON is often a noop.

And from developers.

> BUG_ON() will make us fix it in return for short-term pain.

Pain to our users and testers.  People upon whom we are very dependent and
to whom we are hugely indebted.  People who I have to spend a lot of time
defending from the likes of you!

>  WARN_ON() wont, 
> in return for less pain.  It's mildly better than nothing, but not worth the 
> patch.


