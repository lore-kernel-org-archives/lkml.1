Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbZLTSKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbZLTSKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 13:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbZLTSJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 13:09:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37390 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840AbZLTSJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 13:09:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sun, 20 Dec 2009 19:10:26 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912201210300.24162-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912201210300.24162-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912201910.26895.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 December 2009, Alan Stern wrote:
> On Sun, 20 Dec 2009, Rafael J. Wysocki wrote:
> 
> > > It's too early to come to this sort of conclusion (i.e., that suspend
> > > and resume react very differently to an asynchronous approach).  Unless
> > > you have some definite _reason_ for thinking that resume will benefit
> > > more than suspend, you shouldn't try to generalize so much from tests
> > > on only two systems.
> > 
> > In fact I have one reason.  Namely, the things that drivers do on suspend and
> > resume are evidently quite different and on these two systems I was able to
> > test they apparently took different amounts of time to complete.
> > 
> > The very fact that on both systems resume is substantially longer than suspend,
> > even if all devices are suspended and resumed synchronously, is quite
> > interesting.
> 
> Yes, it is.  But it doesn't mean that suspend won't benefit from 
> asynchronicity; it just means that the benefits might not be as large 
> as they are for resume.

Agreed, although that rises the question whether they are sufficiently
significant.  I guess time will tell.  With the i8042 done asynchronously they
are IMO.

BTW, what's the right place to call device_enable_async_suspend() for USB
devices?

Rafael
