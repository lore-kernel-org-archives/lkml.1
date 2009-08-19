Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbZHSW24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbZHSW24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 18:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZHSW2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 18:28:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40682 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753312AbZHSW2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 18:28:55 -0400
Date: Wed, 19 Aug 2009 18:28:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC][PATCH 1/7] PM: Update kerneldoc comments in
 drivers/base/power/main.c
In-Reply-To: <200908192357.31358.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908191822520.26174-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009, Rafael J. Wysocki wrote:

> On Monday 17 August 2009, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM: Update kerneldoc comments in drivers/base/power/main.c
> > 
> > The kerneldoc comments in drivers/base/power/main.c are generally
> > outdated and some of them don't describe the functions very
> > accurately.  Update them and standardize the format to use spaces
> > instead of tabs.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Any objections to this patch from anyone?  Greg, Alan, Randy?

Just some very minor changes.

> >  /**
> > - *	pm_op - execute the PM operation appropiate for given PM event
> > - *	@dev:	Device.
> > - *	@ops:	PM operations to choose from.
> > - *	@state:	PM transition of the system being carried out.
> > + * pm_op - Execute the PM operation appropiate for given PM event.
> > + * @dev: Device to handle.
> > + * @ops: PM operations to choose from.
> > + * @state: PM transition of the system being carried out.
> >   */

Here and in several places below, "appropriate" is missing an "r".

> >  /**
> > - *	pm_noirq_op - execute the PM operation appropiate for given PM event
> > - *	@dev:	Device.
> > - *	@ops:	PM operations to choose from.
> > - *	@state: PM transition of the system being carried out.
> > + * pm_noirq_op - Execute the PM operation appropiate for given PM event.
> > + * @dev: Device to handle.
> > + * @ops: PM operations to choose from.
> > + * @state: PM transition of the system being carried out.
> >   *
> > - *	The operation is executed with interrupts disabled by the only remaining
> > - *	functional CPU in the system.
> > + * The driver of @dev will not receive interrupts while this fuction is being
> > + * executed.
> >   */

Here and in several places below, "function" is missing an "n".

> >  /**
> > - *	dpm_resume - Resume every device.
> > - *	@state: PM transition of the system being carried out.
> > + * dpm_resume - Execute "resume" callbacks for non-sysdev devices.
> > + * @state: PM transition of the system being carried out.
> >   *
> > - *	Execute the appropriate "resume" callback for all devices the status of
> > - *	which indicates that they are inactive.
> > + * Execute the appropriate "resume" callback for all devices the status of which
> > + * indicates that they are suspended.
> >   */

The phrasing is slightly awkward.  "... all devices whose status
indicates..." would be better.  Below as well.

> >  /**
> > - *	dpm_resume_end - Restore state of each device in system.
> > - *	@state: PM transition of the system being carried out.
> > + * dpm_resume_end - Execute "resume" callbacks and complete system transition.
> > + * @state: PM transition of the system being carried out.
> >   *
> > - *	Resume all the devices, unlock them all, and allow new
> > - *	devices to be registered once again.
> > + * Resume all the devices, unlock them all, and complete the PM transition of
> > + * the system.
> >   */

The "unlock them all" part is a fossil.  It should be removed.

Alan Stern

