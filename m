Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbYHMUQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbYHMUQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYHMUQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:16:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39641 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752380AbYHMUQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:16:06 -0400
Date: Wed, 13 Aug 2008 16:16:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Oliver Neukum <oneukum@suse.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>, <teheo@novell.com>
Subject: Re: Power management for SCSI
In-Reply-To: <1218656526.3237.7.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0808131613400.13982-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008, James Bottomley wrote:

> > With the original patch, you can't operate on the link independent from 
> > the devices.  But with the revised patch (whenever I manage to find 
> > time to write it!), you _will_ be able to.
> 
> That sounds great .. if you link it through the transport class, that
> can implement the policy you want (as in power all devices down before
> the link for USB, but just power down the link for SAS/SATA).

Assuming we have a transport class for USB/Firewire!  That's the reason
I proposed adding such a thing.

Alan Stern

