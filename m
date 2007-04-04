Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbXDDVY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbXDDVY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbXDDVY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:24:58 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:47057 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXDDVY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:24:57 -0400
Date: Wed, 4 Apr 2007 14:26:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Brownell <david-b@pacbell.net>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
Message-Id: <20070404142607.7c0557ae.randy.dunlap@oracle.com>
In-Reply-To: <200704041351.19313.david-b@pacbell.net>
References: <11757099691323-git-send-email-tony@atomide.com>
	<20070404120025.4c5548dc.randy.dunlap@oracle.com>
	<Pine.LNX.4.61.0704042205040.22282@yvahk01.tjqt.qr>
	<200704041351.19313.david-b@pacbell.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 13:51:18 -0700 David Brownell wrote:

> On Wednesday 04 April 2007 1:06 pm, Jan Engelhardt wrote:
> > 
> > On Apr 4 2007 12:00, Randy Dunlap wrote:
> > >
> > >> +static int __init fpga_init(void)
> > >> +{
> > >> +	if (machine_is_omap_h4()
> > >> +			|| machine_is_omap_h3()
> > >> +			|| machine_is_omap_h2()
> > >> +			|| machine_is_omap_perseus2()
> > >> +			)
> > >
> > >Perhaps there is nothing in CodingStyle for if () continuation
> > >lines.  Looks like it is needed.  This is ETOOMUCHINDENTATION by
> > >at least one tab.  Should be more like:
> > >
> > >+	if (machine_is_omap_h4()
> > >+	    || machine_is_omap_h3()
> > >+	    || machine_is_omap_h2()
> > >+	    || machine_is_omap_perseus2())
> > 
> > My stance, || goes at EOL, and final ) not standalone:
> 
> You are still violating the "only TABs used for indent" rule.

Yes, but CodingStyle is a just set of guidelines and common practices.
It doesn't cover multi-line if () statements, which is the subject of
the current controvers^W discussion.


> > 	if (foo ||
> > 	  bar ||
> > 	  baz ||
> > 	  etc)
> > 		do_something;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
