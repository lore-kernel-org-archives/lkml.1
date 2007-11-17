Return-Path: <linux-kernel-owner+w=401wt.eu-S1765128AbXKQUUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765128AbXKQUUQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 15:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759143AbXKQUUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 15:20:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32976 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759247AbXKQUUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 15:20:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
Date: Sat, 17 Nov 2007 21:37:18 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0711161058170.2738-100000@iolanthe.rowland.org> <473F03DF.4020306@gmail.com>
In-Reply-To: <473F03DF.4020306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711172137.18784.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 17 of November 2007, Jiri Slaby wrote:
> On 11/16/2007 05:10 PM, Alan Stern wrote:
> > On Thu, 15 Nov 2007, Greg KH wrote:
> > 
> >>> The offending -mm patch is
> >>> gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
> >>>
> >>> 2.6.24-rc2-mm1 minus it works just fine; PROVE_LOCKING shows nothing new when
> >>> the patch is applied.
> >> Thanks for tracking this down.  Alan, any thoughts?
> > 
> > It's a driver problem somewhere.  Probably not one of the most common 
> > drivers because I don't see the same problem here (but then I'm not 
> > testing -mm).
> > 
> > The thing to do is figure out which driver is causing the problem.
> > Jiri, try enabling CONFIG_DEBUG_DRIVER.  
> 
> Sadly no output.
> 
> > If there's also a config 
> > option to prevent the console from being suspended, set it as well.  
> 
> no_suspend_console kernel parameter has no effect (why?).

I'm not sure.

Please try to set CONFIG_PM_VERBOSE.
