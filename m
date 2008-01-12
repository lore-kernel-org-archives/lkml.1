Return-Path: <linux-kernel-owner+w=401wt.eu-S1763656AbYALLXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763656AbYALLXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 06:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbYALLXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 06:23:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33066 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbYALLW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 06:22:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended (rev. 2)
Date: Sat, 12 Jan 2008 12:25:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
       lenb@kernel.org, linux-kernel@vger.kernel.org, pavel@suse.cz,
       mingo@elte.hu, tglx@linutronix.de, ak@suse.de
References: <20080112005619.GA4665@suse.de> <Pine.LNX.4.44L0.0801112208030.21411-100000@netrider.rowland.org> <20080112042946.GA30093@suse.de>
In-Reply-To: <20080112042946.GA30093@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801121225.44688.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 of January 2008, Greg KH wrote:
> On Fri, Jan 11, 2008 at 10:11:52PM -0500, Alan Stern wrote:
> > On Fri, 11 Jan 2008, Greg KH wrote:
> > 
> > > On Fri, Jan 11, 2008 at 04:49:04PM -0800, Andrew Morton wrote:
> > 
> > > > err, no.  pm-introduce-destroy_suspended_device.patch demolishes
> > > > pm-acquire-device-locks-on-suspend-rev-3.patch
> > > > 
> > > > Confused, giving up.
> > > 
> > > I'm confused too, I have no idea what the proper order of things should
> > > be either.  Anyone want to give me a hint?
> > 
> > Sorry for the confusion.  The correct patch to apply is 
> > pm-acquire-device-locks-on-suspend-rev-3 (plus the attending 
> > style-fixups).  It encompasses those earlier patches.
> 
> Can someone resend this to me?  Do I need to drop the patch I currently
> have in my tree as well?  Or put it before/after that one?
> 
> > The real problem is that our current email workflow patterns don't 
> > provide a standardized way for maintainers to tell when a new patch 
> > submission is meant to override or replace an earlier submission (or 
> > even a set of earlier submissions).  Does anybody have some suggestions 
> > for a good way to do this?
> 
> Yeah, just tell me what you want me to do with it (drop an old one,
> replace it, add it, etc.)  We usually can handle this pretty well :)

I'll repost the new patch along with instructions what to do with it.

Greetings,
Rafael
