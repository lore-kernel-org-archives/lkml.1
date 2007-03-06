Return-Path: <linux-kernel-owner+w=401wt.eu-S1750911AbXCFU2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911AbXCFU2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbXCFU2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:28:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45117 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbXCFU2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:28:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Problem with freezable workqueues
Date: Tue, 6 Mar 2007 21:31:22 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
References: <200702272251.28844.rjw@sisk.pl> <1173141019.15891.39.camel@johannes.berg>
In-Reply-To: <1173141019.15891.39.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703062131.23465.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, 6 March 2007 01:30, Johannes Berg wrote:
> On Tue, 2007-02-27 at 22:51 +0100, Rafael J. Wysocki wrote:
> 
> > For 2.6.21-rc1 I've invented the appended workaround (works for me, waiting for
> > Johannes to confirm it works for him too), but I think we need something better
> > for -mm and future kernels.
> 
> Finally I could get back to this but after reading the thread I figured
> it might not be necessary to test this. Please let me know ASAP if you
> want this patch tested as well or it'll take quite a long time (going
> skiing for a week on Saturday)

I think it won't be necessary.

For now, we have decided to make the workqueues nonfreezable (the patch for
that has already been merged, AFAICT).

> In any case, I made the two xfs workqueues non-freezable and everything
> on my quad powermac works again, I also couldn't detect any filesystem
> correction.

Good, thanks for the confirmation.

> I wanted to adapt the BUG_ON(block IO not from suspend code) 
> patch from suspend2 but haven't gotten around to it yet.

That might be a good idea for other reasons too, but I'd prefer WARN_ON()
instead of BUG_ON() when you're at it. ;-)

Greetings,
Rafael
