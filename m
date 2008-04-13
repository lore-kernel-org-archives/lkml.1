Return-Path: <linux-kernel-owner+w=401wt.eu-S1758900AbYDMNfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900AbYDMNfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 09:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbYDMNfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 09:35:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35518 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbYDMNfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 09:35:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 7)
Date: Sun, 13 Apr 2008 15:31:09 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200804040111.15255.rjw@sisk.pl> <200804040112.45769.rjw@sisk.pl> <20080412002302.GA27656@kroah.com>
In-Reply-To: <20080412002302.GA27656@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804131531.11650.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 of April 2008, Greg KH wrote:
> On Fri, Apr 04, 2008 at 01:12:44AM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Introduce 'struct pm_ops' and 'struct pm_ext_ops' ('ext' meaning
> > 'extended') representing suspend and hibernation operations for bus
> > types, device classes, device types and device drivers.
> 
> <snip>
> 
> This is probably because I took a few days to merge this, but it doesn't
> apply to my tree anymore, with some wierd merge errors that I don't
> think I can easily resolve without having to totally guess as to what it
> should be (the apm_32.c area especially...)
> 
> Care to respin these patches?

Sure, they'll go in replies to this message.  They include a couple of fixes
from Andrew that are in -mm.

I have tested them on top of the current linux-next with
pm-remove-destroy_suspended_device.patch, so they should apply to your tree
this time.

> Sorry for the delay. 

No big deal.

Thanks,
Rafael

