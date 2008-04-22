Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbYDVUO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbYDVUO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYDVUOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:14:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46175 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbYDVUOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:14:47 -0400
Date: Tue, 22 Apr 2008 21:14:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Randy Dunlap <RANDY.DUNLAP@ORACLE.COM>, linux-kernel@vger.kernel.org,
       philipp.zabel@gmail.com
Subject: Re: pasic3 allmod/yesconfig build error
Message-ID: <20080422201423.GE9911@flint.arm.linux.org.uk>
References: <28221442.1208881240429.JavaMail.oracle@acsmt302.oracle.com> <20080422194933.GB9911@flint.arm.linux.org.uk> <1208894601.24124.7.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208894601.24124.7.camel@brick>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:03:21PM -0700, Harvey Harrison wrote:
> On Tue, 2008-04-22 at 20:49 +0100, Russell King - ARM Linux wrote:
> > On Tue, Apr 22, 2008 at 11:20:40AM -0500, Randy Dunlap wrote:
> > > allmodconfig and allyesconfig on $ARCH try to build the htc-pasic3 driver,
> > > but it fails due to wanting <asm/arch/pxa-regs.h>.
> > > 
> > > Should the Kconfig file be modified to build this driver only for $ARCH=arm ?
> > 
> > Known problem.  You're about the 4th person in the last 24 hours to
> > report this.
> > 
> > It's been known about since Sunday.  Unfortunately, Linus not responding
> > to emails until midnight (my time) on Monday meant that I've not been able
> > to do anything about it, despite having a fix (along with others) already
> > merged but not properly queued up (because I didn't know what Linus was
> > going to do.)
> > 
> > So... I'm not going to be able to properly sort my tree until Thursday.
> > Please ignore it until Friday.  Thanks.
> 
> People make mistakes, it happens.  For people who have hit this, do you
> have a tree they can pull from to get the fixes?

Not yet.

> > (Please note that these reports are stressing me because I have the fix,
> > I've known about it for ages, but because of factors out of my control -
> > and community policy, in so far as "you do not change the tree you've asked
> > to be pulled from" I'd have been unable to resolve it and all the other
> > stupid breakage in that pull before anyone saw it.  I suppose what I
> > should've done was deleted the tree of kernel.org so Linus _couldn't_
> > pull it.)
> 
> Couldn't you just send Linus another pull request with further fixes?

So... no.  And the reason I'm saying Thursday is because I do not work
on the kernel every day of the week - in fact, I'm not in front of a
computer for three days of the working week.

So... Thursday.  Not earlier.  Be patient.

Bear in mind that I waited patiently on Monday - _all_ _day_ Monday - to
know how to fix these issues.  So the least everyone can do _for_ _me_
is to be patient over it and just plain wait until I can sort it.

Just like Linus is entitled to time off, I'm entitled to time off.  My
time off is just at a different time to normal folk.

Patience.
