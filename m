Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZCNXmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZCNXmy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 19:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbZCNXmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 19:42:45 -0400
Received: from fed1rmpop107.cox.net ([68.230.241.11]:34084 "EHLO
	fed1rmpop107.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZCNXmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 19:42:44 -0400
X-Greylist: delayed 943 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Mar 2009 19:42:44 EDT
X-Authority-Analysis: v=1.0 c=1 a=rDF_XFhH7-gA:10 a=DiAPenQi9D4A:10
 a=6E_3W0waWl8C76PiPNEA:9 a=MX3jiU2pmv0VIyO879x3jb_a2y8A:4 a=owhbxUb_RjYA:10
X-CM-Score: 0.00
From: Chris Brannon <cmbrannon@cox.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
In-reply-to: <20090312181225.GC26099@tuxbookpro.rit.edu>
References: <20090304031238.WCEC18213.eastrmmtao106.cox.net@eastrmimpo03.cox.net> <1f1b08da0903061456g7621f92cx8a1e251249d739ac@mail.gmail.com> <20090307162327.PQGL18213.eastrmmtao106.cox.net@eastrmimpo02.cox.net> <20090312181225.GC26099@tuxbookpro.rit.edu>
Date: Sat, 14 Mar 2009 18:27:04 -0500
Message-Id: <20090314232700.BNAW15318.fed1rmmtao105.cox.net@fed1rmimpo01.cox.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.R. Mauro wrote:
> On Sat, Mar 07, 2009 at 10:23:05AM -0600, Chris Brannon wrote:
> > John Stultz wrote:
> > > Ehh. Why would we want to export raw kernel internal values like
> > > jiffies and HZ?
> > > 
> > > I think the CLOCK_MONOTONIC clockid would probably be a better value to
> > > export.
> > 
> > I'll look at CLOCK_MONOTONIC clockid.  I'm more than glad to export
> > something > more appropriate, including nothing at all (dummy values,
> > perhaps).
> 
> Chris, are the current values exactly what one would get if reading /dev/time
> onPlan 9?
> If possible, it would be nice to aim for 100% compatibility as there are
> folks trying to get complete Plan 9 binary compatibility working in Linux.

On Plan 9, the last two values are architecture-dependent.
I rewrote my patch to export nanoseconds since boot and nanoseconds per
second, but either choice should be ok from the standpoint of compatibility.

I am going to rework this patch to eliminate the inconsistencies
with the Plan 9 interface.

Thanks to Jochen Vos for pointing out the error in the documentation.
I forgot to change my example to reflect the change to the code.

-- Chris
