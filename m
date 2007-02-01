Return-Path: <linux-kernel-owner+w=401wt.eu-S1161160AbXBAFaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161160AbXBAFaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 00:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161177AbXBAFaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 00:30:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:54854 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161160AbXBAFap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 00:30:45 -0500
X-Authenticated: #14349625
Subject: Re: 2.6.19.2 oops after resume from ram (corruption?)
From: Mike Galbraith <efault@gmx.de>
To: nigel@nigel.suspend2.net
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1170279722.5389.19.camel@nigel.suspend2.net>
References: <1170241008.6512.10.camel@Homer.simpson.net>
	 <1170279722.5389.19.camel@nigel.suspend2.net>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 06:30:34 +0100
Message-Id: <1170307834.7087.16.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 08:42 +1100, Nigel Cunningham wrote:
> Hi.
> 
> On Wed, 2007-01-31 at 11:56 +0100, Mike Galbraith wrote:
> > Greetings,
> > 
> > I received the below upon first poke of firefox icon after a resume.  
> 
> Are you able to reproduce it reliably? Failing that, could you try
> enabling some the kernel configuration options that help with debugging
> memory corruption (slab corruption checking in particular will probably
> be the most useful thing here).

No, it's a never before seen event.  That said, I have had a couple of
dead box after resume events with other kernels in the last few months,
so I may have had corruption of a more deadly variety.  Unfortunately,
when I'm resuming, my serial console box is almost guaranteed to be off.

Rebuilding this particular kernel with slab debugging would probably be
a waste of time since stable kernels get very little runtime here, but
I'll re-add it to my config for test kernels just in case a survivable
event should happen.

	-Mike

