Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbYALDMC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbYALDMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 22:12:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbYALDLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 22:11:53 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2957 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756503AbYALDLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 22:11:52 -0500
Date: Fri, 11 Jan 2008 22:11:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, <rjw@sisk.pl>,
       <linux-pm@lists.linux-foundation.org>, <linux-acpi@vger.kernel.org>,
       <lenb@kernel.org>, <linux-kernel@vger.kernel.org>, <pavel@suse.cz>,
       <mingo@elte.hu>, <tglx@linutronix.de>, <ak@suse.de>
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended
 (rev. 2)
In-Reply-To: <20080112005619.GA4665@suse.de>
Message-ID: <Pine.LNX.4.44L0.0801112208030.21411-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008, Greg KH wrote:

> On Fri, Jan 11, 2008 at 04:49:04PM -0800, Andrew Morton wrote:

> > err, no.  pm-introduce-destroy_suspended_device.patch demolishes
> > pm-acquire-device-locks-on-suspend-rev-3.patch
> > 
> > Confused, giving up.
> 
> I'm confused too, I have no idea what the proper order of things should
> be either.  Anyone want to give me a hint?

Sorry for the confusion.  The correct patch to apply is 
pm-acquire-device-locks-on-suspend-rev-3 (plus the attending 
style-fixups).  It encompasses those earlier patches.

The real problem is that our current email workflow patterns don't 
provide a standardized way for maintainers to tell when a new patch 
submission is meant to override or replace an earlier submission (or 
even a set of earlier submissions).  Does anybody have some suggestions 
for a good way to do this?

Alan Stern


