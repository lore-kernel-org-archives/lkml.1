Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbYC0Cz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbYC0Cz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 22:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbYC0CzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 22:55:15 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1047 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753701AbYC0CzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 22:55:14 -0400
Date: Wed, 26 Mar 2008 22:55:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Brad Sawatzky <brad+kernel@swatter.net>
cc: Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-serial: fix regression in Visor/Palm OS module for
 kernels >= 2.6.24
In-Reply-To: <20080327001557.GA16176@enigma.swatter.net>
Message-ID: <Pine.LNX.4.44L0.0803262252420.21714-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Brad Sawatzky wrote:

> On Wed, 26 Mar 2008, Oliver Neukum wrote:
> 
> > Am Mittwoch, 26. März 2008 03:32:43 schrieb Brad Sawatzky:
> [ . . . ]
> > > I suppose it's possible that the kernel is identifying 3 bulk endpoints
> > > when there should only be 2 and there is some issue with the lower level
> > > endpoint probe?
> > 
> > Send in "lsusb -v". Are you sure all devices have 3 endpoints?
> 
> Seems to:

You did not understand Oliver's question.  Yes, your device has 3
bulk-OUT endpoints (and 2 bulk-IN).  But do you know whether _all_
Visor/Palm OS devices do?  If they don't, your patch will cause the
driver to stop working when someone plugs in a device with only 2
endpoints.

Alan Stern

