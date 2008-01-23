Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbYAWTgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbYAWTgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYAWTfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:35:54 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:39552 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbYAWTfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:35:53 -0500
Subject: Re: [PATCH 3/4] ACPI: Check for any matching CID when walking
	namespace.
From: Andrew Patterson <andrew.patterson@hp.com>
To: Greg KH <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       lenb@kernel.org, gregkh@suse.de, matthew@wil.cx, tom.l.nguyen@intel.com,
       linux-acpi@vger.kernel.org
In-Reply-To: <20080123174253.GA10387@kroah.com>
References: <20080123001807.28190.32648.stgit@bluto.andrew>
	 <20080123001822.28190.3147.stgit@bluto.andrew>
	 <20080123174253.GA10387@kroah.com>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 12:35:51 -0700
Message-Id: <1201116951.12916.128.camel@bluto.andrew>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-23 at 09:42 -0800, Greg KH wrote:
> On Tue, Jan 22, 2008 at 05:18:22PM -0700, Andrew Patterson wrote:
> > From: Andrew Patterson <andrew.patterson@hp.com>
> > 
> > The callback function acpi_ns_get_device_callback called from
> > acpi_get_devices() will check CID's if the HID does not match.  This code
> > has a bug where it requires that all CIDs match the HID. Changed the code
> > so that any CID match will do.
> > 
> > Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
> > ---
> > 
> >  drivers/acpi/namespace/nsxfeval.c |   11 ++++++++---
> >  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> This should probably go through the ACPI tree, not the PCI tree, right?
> 

Yes, but it is needed to get PCIe AER working (at least on the systems
that I have seen).  I suspect we will have the same issue with PCIe
hotplug. Len Brown is looking at it.

> thanks,
> 
> greg k-h


