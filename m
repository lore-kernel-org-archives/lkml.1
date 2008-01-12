Return-Path: <linux-kernel-owner+w=401wt.eu-S1761773AbYALDWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761773AbYALDWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 22:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757883AbYALDWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 22:22:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39345 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbYALDWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 22:22:23 -0500
Date: Fri, 11 Jan 2008 19:21:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, <rjw@sisk.pl>,
       <linux-pm@lists.linux-foundation.org>, <linux-acpi@vger.kernel.org>,
       <lenb@kernel.org>, <linux-kernel@vger.kernel.org>, <pavel@suse.cz>,
       <mingo@elte.hu>, <tglx@linutronix.de>, <ak@suse.de>
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended
 (rev. 2)
Message-Id: <20080111192134.52769758.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0801112208030.21411-100000@netrider.rowland.org>
References: <20080112005619.GA4665@suse.de>
	<Pine.LNX.4.44L0.0801112208030.21411-100000@netrider.rowland.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 22:11:52 -0500 (EST) Alan Stern <stern@rowland.harvard.edu> wrote:

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
> 
> The real problem is that our current email workflow patterns don't 
> provide a standardized way for maintainers to tell when a new patch 
> submission is meant to override or replace an earlier submission (or 
> even a set of earlier submissions).  Does anybody have some suggestions 
> for a good way to do this?
> 

Don't formally send it until it's ready.  Seriously.  You can always resend
it if it didn't get applied anywhere.

Once a patch reaches a sufficient level of maturity for it to be ready to
be merged into a subsystem tree, any subsequent changes should be
sufficiently small that incremental patches are the way to apply touchups.

The core problem here is that (lots of) people are flinging patches at
tree-owners before they are sufficiently baked.
