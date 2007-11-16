Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbXKPQKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbXKPQKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 11:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750705AbXKPQKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 11:10:30 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53077 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750820AbXKPQKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 11:10:30 -0500
Date: Fri, 16 Nov 2007 11:10:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Jiri Slaby <jirislaby@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
In-Reply-To: <20071116003836.GA24490@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711161058170.2738-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Greg KH wrote:

> > The offending -mm patch is
> > gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
> > 
> > 2.6.24-rc2-mm1 minus it works just fine; PROVE_LOCKING shows nothing new when
> > the patch is applied.
> 
> Thanks for tracking this down.  Alan, any thoughts?

It's a driver problem somewhere.  Probably not one of the most common 
drivers because I don't see the same problem here (but then I'm not 
testing -mm).

The thing to do is figure out which driver is causing the problem.
Jiri, try enabling CONFIG_DEBUG_DRIVER.  If there's also a config 
option to prevent the console from being suspended, set it as well.  
Then you should be able to tell which driver is making trouble.

Alan Stern

