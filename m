Return-Path: <linux-kernel-owner+w=401wt.eu-S1761748AbXKTTyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761748AbXKTTyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 14:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXKTTyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 14:54:09 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47900 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbXKTTyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 14:54:07 -0500
Date: Tue, 20 Nov 2007 11:53:59 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Gary Hade <garyhade@us.ibm.com>, Alex Chiang <achiang@hp.com>,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       kaneshige.kenji@jp.fujitsu.com, pcihpd-discuss@lists.sourceforge.net,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20071120195359.GB11694@us.ibm.com>
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com> <20071120020402.GA26446@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120020402.GA26446@srcf.ucam.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 02:04:02AM +0000, Matthew Garrett wrote:
> On Mon, Nov 19, 2007 at 03:32:25PM -0800, Gary Hade wrote:
> 
> > Alex, What I was trying to suggest is a boot-time kernel option, 
> > not a kernel configuration option.  The basic idea is to give
> > the user (with a single binary kernel) the ability to include
> > your ACPI-PCI slot driver feature changes only when they are
> > really needed.  In addition to reducing the number of
> > system/PCI hotplug driver combinations where your changes
> > would need to be validated, I believe would also help 
> > alleviate other worries (e.g. Andi Kleen's memory consumption
> > concern).  I believe this goal could also be achieved with the
> > kernel config option by making the pci_slot module runtime
> > loadable with the PCI hotplug drivers only visiting your new
> > code when the pci_slot driver is loaded, although I think this
> > would be more difficult to implement.
> 
> If we're compiling something into the kernel, the default behaviour 
> should be for the functionality to be turned on unless the user 
> overrides it.

It seems like others could have a problem with this but as
long as there is a way to exclude the functionality in the
event of problems without a kernel rebuild, "on" by default
would work for me.

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

