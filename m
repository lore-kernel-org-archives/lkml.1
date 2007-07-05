Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbXGEOeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbXGEOeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761563AbXGEOeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:34:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761494AbXGEOee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:34:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: removing refrigerator does not help with s2ram vs. fuse deadlocks (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Date: Thu, 5 Jul 2007 16:41:39 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Paul Mackerras <paulus@samba.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <18059.6726.218205.104212@cargo.ozlabs.ibm.com> <200707051628.12199.rjw@sisk.pl> <20070705142600.GB22598@srcf.ucam.org>
In-Reply-To: <20070705142600.GB22598@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051641.39998.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 16:26, Matthew Garrett wrote:
> On Thu, Jul 05, 2007 at 04:28:11PM +0200, Rafael J. Wysocki wrote:
> > On Thursday, 5 July 2007 15:57, Matthew Garrett wrote:
> > > And also "Userland should not depend on userland services", which is 
> > > rather more of a problem.
> > 
> > I think you're oversimplifying it, as far as FUSE is concerned.
> > 
> > Namely, if there are two userland tasks, A and B, and B is uninterruptible,
> > because A is blocked, then this is not a usual situation.
> 
> Fuse is one case of it occuring, and if we end up with more userspace 
> drivers then the problem is only going to get worse.

But this is a problem by itself, regardless of the freezer etc., no?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
