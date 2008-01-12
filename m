Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbYALE2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbYALE2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 23:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYALE2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 23:28:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:60099 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbYALE2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 23:28:08 -0500
Date: Fri, 11 Jan 2008 20:29:46 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
       lenb@kernel.org, linux-kernel@vger.kernel.org, pavel@suse.cz,
       mingo@elte.hu, tglx@linutronix.de, ak@suse.de
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended
	(rev. 2)
Message-ID: <20080112042946.GA30093@suse.de>
References: <20080112005619.GA4665@suse.de> <Pine.LNX.4.44L0.0801112208030.21411-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0801112208030.21411-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 10:11:52PM -0500, Alan Stern wrote:
> On Fri, 11 Jan 2008, Greg KH wrote:
> 
> > On Fri, Jan 11, 2008 at 04:49:04PM -0800, Andrew Morton wrote:
> 
> > > err, no.  pm-introduce-destroy_suspended_device.patch demolishes
> > > pm-acquire-device-locks-on-suspend-rev-3.patch
> > > 
> > > Confused, giving up.
> > 
> > I'm confused too, I have no idea what the proper order of things should
> > be either.  Anyone want to give me a hint?
> 
> Sorry for the confusion.  The correct patch to apply is 
> pm-acquire-device-locks-on-suspend-rev-3 (plus the attending 
> style-fixups).  It encompasses those earlier patches.

Can someone resend this to me?  Do I need to drop the patch I currently
have in my tree as well?  Or put it before/after that one?

> The real problem is that our current email workflow patterns don't 
> provide a standardized way for maintainers to tell when a new patch 
> submission is meant to override or replace an earlier submission (or 
> even a set of earlier submissions).  Does anybody have some suggestions 
> for a good way to do this?

Yeah, just tell me what you want me to do with it (drop an old one,
replace it, add it, etc.)  We usually can handle this pretty well :)

thanks,

greg k-h
