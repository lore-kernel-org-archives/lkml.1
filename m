Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbXCPUk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbXCPUk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbXCPUk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:40:56 -0400
Received: from www.osadl.org ([213.239.205.134]:35850 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753259AbXCPUkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:40:55 -0400
Subject: Re: Linux 2.6.21-rc4
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= RISS <frederic.riss@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>, Milan Broz <mbroz@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703162134.14265.rjw@sisk.pl>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <200703162134.14265.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 21:47:45 +0100
Message-Id: <1174078066.13341.279.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 21:34 +0100, Rafael J. Wysocki wrote:
> On Friday, 16 March 2007 17:33, Linus Torvalds wrote:
> > 
> > I pushed out the -git trees yesterday, but then got distracted, so the 
> > patches and tar-balls and the announcement got delayed until this morning. 
> > Oops. I'm a scatter-brain.
> > 
> > Anyway, the good news about -rc4 is that there's just lots of random 
> > fixes. I'm hoping that we've seriously cut down on the regression list, 
> > and I'd ask everybody who is on Adrian's list to please re-verify their 
> > regression, and in case it's one of the "patches available" ones but I 
> > haven't merged (maybe because it hasn't been sent to me!), make sure I do.
> 
> I'm afraid that if CONFIG_TICK_ONESHOT or CONFIG_NO_HZ is set, we still have a
> problem with RCU synchronization while nonboot CPUs are being enabled during a
> resume (http://lkml.org/lkml/2007/3/11/144, http://lkml.org/lkml/2007/3/4/88).
> 
> Can someone who had this problem with -rc3 check if it's present in -rc4?

I finally found a box today, which shows this problem. I'm working on a
fix.

	tglx


