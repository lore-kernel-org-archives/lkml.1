Return-Path: <linux-kernel-owner+w=401wt.eu-S1762477AbXGFPNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762477AbXGFPNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbXGFPNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:13:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55809 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754428AbXGFPNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:13:15 -0400
Date: Fri, 6 Jul 2007 11:13:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Paul Mackerras <paulus@samba.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <1183676393.3388.89.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0707061111050.3737-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Benjamin Herrenschmidt wrote:

> Why are you guys working so hard and spending so much energy to try to
> avoid doing the right thing is beyond my understanding...
> 
> > It _does_ apply to kernel threads.  That's exactly why I wrote above 
> > that kernel threads which try to do I/O during a suspend will need 
> > extra attention.
> 
> Ok none at all if you don't have a freezer.

In answer to both questions: We need the freezer in order to implement 
hibernate.  Even if we take your advice and stop using the freezer 
during suspend, these issues would still remain and would need to be 
solved.

Alan Stern

