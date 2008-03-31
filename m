Return-Path: <linux-kernel-owner+w=401wt.eu-S1751723AbYCaNhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbYCaNhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 09:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbYCaNhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 09:37:23 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:53553 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750863AbYCaNhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 09:37:22 -0400
Subject: Re: [PATCH 1/2] sysfs: allow the group is_visible() method to
	return a mode and add an update API
From: Kay Sievers <kay.sievers@vrfy.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, Hannes Reinecke <hare@suse.de>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1206896083.4224.40.camel@localhost.localdomain>
References: <1206134832.2961.64.camel@localhost.localdomain>
	 <20080321222635.GA2674@kroah.com>
	 <1206208949.4393.25.camel@localhost.localdomain>
	 <1206896083.4224.40.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Mon, 31 Mar 2008 15:42:09 +0200
Message-Id: <1206970929.20492.27.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-30 at 11:54 -0500, James Bottomley wrote:
> On Sat, 2008-03-22 at 13:02 -0500, James Bottomley wrote:
> > On Fri, 2008-03-21 at 15:26 -0700, Greg KH wrote:
> > > On Fri, Mar 21, 2008 at 04:27:12PM -0500, James Bottomley wrote:
> > > > We have a problem in scsi_transport_spi in that we need to customise
> > > > not only the visibility of the attributes, but also their mode.  Fix
> > > > this by making the is_visible() callback return a mode, with 0
> > > > indicating is not visible.
> > > > 
> > > > Also add a sysfs_update_group() API to allow us to change either the
> > > > visibility or mode of the files at any time on the fly.
> > > > 
> > > > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > > ---
> > > > 
> > > > Greg, can I take this through SCSI, please ... assuming it's OK?  We
> > > > need this to fix up the SPI transport class.
> > > 
> > > Sure.  But can you document that "update" field a bit more so we can
> > > remember what it means in the future?
> > 
> > How about this?  I also added docbook for create and update attribute
> > group.

Looks good to me.

I think with the "visible" stuff for attribute groups, will be able to
fix the USB event timing problem, by moving the creation of the device
attributes to default attributes. So I'm looking forward to have this in
the tree.

> Can I get an ACK from someone from sysfs for this, please?

> > ---
> > 
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date: Thu, 20 Mar 2008 20:47:52 -0500
> > Subject: [SCSI] sysfs: make group is_valid return a mode_t
> > 
> > We have a problem in scsi_transport_spi in that we need to customise
> > not only the visibility of the attributes, but also their mode.  Fix
> > this by making the is_visible() callback return a mode, with 0
> > indicating is not visible.
> > 
> > Also add a sysfs_update_group() API to allow us to change either the
> > visibility or mode of the files at any time on the fly.

Acked-by: Kay Sievers <kay.sievers@vrfy.org>

> > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

﻿Thanks for doing this,
Kay


