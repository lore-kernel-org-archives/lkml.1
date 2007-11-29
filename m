Return-Path: <linux-kernel-owner+w=401wt.eu-S934029AbXK2U1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029AbXK2U1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932656AbXK2U0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:26:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:59556 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826AbXK2U0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:26:52 -0500
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before
	kobject_init
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <1196367597.7903.25.camel@lov.site>
References: <Pine.LNX.4.44L0.0711291455410.5666-100000@iolanthe.rowland.org>
	 <1196367597.7903.25.camel@lov.site>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 21:26:40 +0100
Message-Id: <1196368000.7903.28.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/FxghIjaGtRzzaKQcE1CXgDCuhpzUpHDmjPG6
 73AM5Hvktf71644qvGqwPnYl0UpHGKYblF6ZqThR73iVJ3P83o
 dHSdTPBC33x7lIK6DHHe42CIf8J5Exx
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-29 at 21:20 +0100, Kay Sievers wrote:
> On Thu, 2007-11-29 at 15:09 -0500, Alan Stern wrote:
> > On Thu, 29 Nov 2007, Kay Sievers wrote:

> > > > There's another good reason for not assigning the name in
> > > > kobject_init(): Code that uses kobjects (like the driver core) doesn't
> > > > set the name until later.
> > > 
> > > That can be done at any stage, I guess. We will rip out the name in the
> > > struct device anyway.
> > 
> > Are you also going to change all the places in the kernel where the
> > device name (.bus_id) isn't set until after device_initialize() has
> > been called?
> 
> Yes, I already have a patch that does that for all stuff that was needed
> on my boxes.

To be exact, bus_id will be removed from the device, and the device name
will be set and retrieved directly from the kobject.

Kay

