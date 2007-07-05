Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbXGEPUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbXGEPUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 11:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757497AbXGEPUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 11:20:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54071 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448AbXGEPUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 11:20:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: removing refrigerator does not help with s2ram vs. fuse deadlocks (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Date: Thu, 5 Jul 2007 17:27:35 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Paul Mackerras <paulus@samba.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <18059.6726.218205.104212@cargo.ozlabs.ibm.com> <200707051704.48137.rjw@sisk.pl> <20070705150301.GB23647@srcf.ucam.org>
In-Reply-To: <20070705150301.GB23647@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051727.36715.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 17:03, Matthew Garrett wrote:
> On Thu, Jul 05, 2007 at 05:04:47PM +0200, Rafael J. Wysocki wrote:
> > On Thursday, 5 July 2007 16:39, Matthew Garrett wrote:
> > > Why?
> > 
> > You have processes that don't react to signals, because some other user land
> > task is misbehaving.  I'd call that ugly at the very least.
> 
> It already happens with, say, NFS. Don't think about it in terms of a 
> userland task misbehaving - think of it in terms of a resource becoming 
> unavailable.

I think there's a difference between a userland task playing the role of a
resource and a "real" external resource the kernel doesn't control.

IMO, userland tasks should not have the power to affect each other as though
they were parts of the kernel.

Greetings,
Rafael
 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
