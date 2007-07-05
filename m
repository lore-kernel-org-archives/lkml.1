Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbXGEOU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbXGEOU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757164AbXGEOUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:20:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53803 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756362AbXGEOUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:20:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: removing refrigerator does not help with s2ram vs. fuse deadlocks (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Date: Thu, 5 Jul 2007 16:28:11 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Paul Mackerras <paulus@samba.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <18059.6726.218205.104212@cargo.ozlabs.ibm.com> <20070705091526.GA3084@elf.ucw.cz> <20070705135758.GB22177@srcf.ucam.org>
In-Reply-To: <20070705135758.GB22177@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051628.12199.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 15:57, Matthew Garrett wrote:
> On Thu, Jul 05, 2007 at 11:15:26AM +0200, Pavel Machek wrote:
> 
> > Now, if kernel needs FUSE services for some reason (that's the problem
> > we hit in s2ram case, right?), we have a deadlock.
> > 
> > So main problem still seems to be "kernel should not depend on
> > userland services during suspend", refrigerator or not.
> 
> And also "Userland should not depend on userland services", which is 
> rather more of a problem.

I think you're oversimplifying it, as far as FUSE is concerned.

Namely, if there are two userland tasks, A and B, and B is uninterruptible,
because A is blocked, then this is not a usual situation.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
