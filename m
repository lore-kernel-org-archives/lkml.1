Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZKPVGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZKPVGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZKPVGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:06:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60964 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbZKPVGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:06:03 -0500
Date: Mon, 16 Nov 2009 21:05:45 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [RFC][PATCH 1/10] PM: Add flag for devices capable of
	generating run-time wake-up events
Message-ID: <20091116210545.GA29696@srcf.ucam.org>
References: <200911162152.38333.rjw@sisk.pl> <Pine.LNX.4.44L0.0911161557130.2971-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0911161557130.2971-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 04:00:49PM -0500, Alan Stern wrote:
> On Mon, 16 Nov 2009, Rafael J. Wysocki wrote:
> > Yes, in general.  The platform.
> 
> And for non-platform devices (hot-pluggable, for example)?  Presumably 
> you would want the driver that detects and registers the device to set 
> this flag.

Are there any cases where the bus code won't know this?

> > > What if the kernel can't tell whether or not the device can generate 
> > > runtime wake-up events?
> > 
> > Do you have any specific examples in mind?
> 
> What about Matthew's example of an ACPI GPE which might or might not 
> cause a runtime wake-up event, depending on the AML code in the BIOS?

The platform knows whether or not that's the case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
