Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbXITUwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbXITUwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbXITUv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:51:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:34147 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbXITUv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:51:58 -0400
Date: Thu, 20 Sep 2007 13:50:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rob Landley <rob@landley.net>
Cc: linux-tiny@selenic.com, Tim Bird <tim.bird@am.sony.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Michael Opdenacker <michael@free-electrons.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>
Subject: Re: Monster switch for small size (was Linux-tiny revival)
Message-Id: <20070920135002.b00d8e64.randy.dunlap@oracle.com>
In-Reply-To: <200709201641.22580.rob@landley.net>
References: <46F1645D.9050406@am.sony.com>
	<20070920091042.GA6035@shadowen.org>
	<46F2A99A.3080400@am.sony.com>
	<200709201641.22580.rob@landley.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 16:41:22 -0500 Rob Landley wrote:

> On Thursday 20 September 2007 12:10:50 pm Tim Bird wrote:
> > Andy Whitcroft wrote:
> > > Knowing nothing about these options, from a test perspective it would
> > > be nice if we were able to simply enable "the lot" so we can do "normal"
> > > -mm runs and "tiny" -mm runs without any manual intervention?
> >
> > I agree completely.
> >
> > I have been thinking for a while about how to make a "monster switch"
> > (the kind they always seem to have in Frankenstein movies) that
> > switches a whole bunch of settings at once.  We currently have methods
> > in the kernel for:
> >  * default (or recommended) config for a particular platform
> >  * all yes - to build as much as possible
> >  * all no - to build as little as possible
> >
> > The problem with "allno" is that it rarely produces a usable
> > kernel.
> 
> Beyond that, allno doesn't come close to switching everything off.
> 
> 1) You have to _enable_ CONFIG_EMBEDDED in order to go into that menu and 
> switch _off_ the stuff in there.
> 
> 2) The stuff CONFIG_EMBEDDED reveals isn't all in that menu.  CONFIG_BLOCK is 
> at the top level menu.  CONFIG_VT and CONFIG_UNIX98_PTYS are buried down 
> under device drivers->character devices, and there's more sprinkled all over.  
> You have to track it all down and switch it off to get an _actual_ 
> allnoconfig kernel.
> 
> (I cut the bit where you reinvent miniconfig.  People keep doing this.  I dig 

I noticed that too.

> it up and resubmit it every year or so, so Roman Zippel can shoot it down 
> again.  Meanwhile, not only is Firmware Linux happily using it, but I even 
> wrote more documentation at 
> http://landley.net/code/firmware/new_platform.html although you have to 
> scroll down a bit to get to the stuff about miniconfig...)

I use it for daily build/boot/run-some-number-like-30-tests kernel testing.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
