Return-Path: <linux-kernel-owner+w=401wt.eu-S1763570AbZALW5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763570AbZALW5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760315AbZALWyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:54:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46378 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763292AbZALWyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:54:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Regression] USB wakeup problem on Toshiba Portege R500
Date: Mon, 12 Jan 2009 23:53:59 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Frans Pop <elendil@planet.nl>, oliver@neukum.org, gregkh@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, pavel@suse.cz,
       torvalds@linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0901121649470.13021-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0901121649470.13021-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901122353.59887.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009, Alan Stern wrote:
> On Fri, 9 Jan 2009, Rafael J. Wysocki wrote:
> 
> > > My proposal:
> > > 
> > > 	Devices and events that are clearly associated with system
> > > 	wakeup should be enabled by default.  For example: Power
> > > 	button and laptop lid.
> > 
> > Agreed.
> > 
> > > 	All other devices capable of waking up the system should be
> > > 	disabled by default.  This presumably includes every PCI
> > > 	device.  If users want keyboard or mouse events to cause
> > > 	a system resume then they will have to configure their
> > > 	desktop management program to enable it.
> > 
> > I generally agree, with one exception.  There are network adapters which
> > can be enabled to wake up by the BIOS and their drivers set them up for WoL
> > currently on this basis.  These should remain enabled IMO.
> 
> How do we know which adapters these are?  IMO the PCI core should
> disable wakeup by default for all devices when they are detected.

This is what we do.

> Is it sufficient to have the adapter drivers enable wakeup during
> their probe routines?

Yes, it is.

Thanks,
Rafael
