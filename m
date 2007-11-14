Return-Path: <linux-kernel-owner+w=401wt.eu-S1762562AbXKNRyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762562AbXKNRyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762060AbXKNRxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:53:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52243 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762034AbXKNRxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:53:36 -0500
Date: Wed, 14 Nov 2007 09:51:51 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alex Chiang <achiang@hp.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, matthew@wil.cx, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071114175151.GA14994@kroah.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113202154.GA22812@ldl.fc.hp.com> <20071113202632.GA3227@kroah.com> <20071114174401.GA4265@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114174401.GA4265@srcf.ucam.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 05:44:01PM +0000, Matthew Garrett wrote:
> On Tue, Nov 13, 2007 at 12:26:32PM -0800, Greg KH wrote:
> 
> > Doesn't /sys/firmware/acpi give you raw access to the correct tables
> > already?
> > 
> > And isn't there some other tool that dumps the raw ACPI tables?  I
> > thought the acpi developers used it all the time when debugging things
> > with users.
> 
> Dumping raw ACPI tables isn't adequate - _SUN might be a complex ACPI 
> method with multiple reads and writes to raw hardware, and we really 
> don't want to do that in userspace. The only way to do this reliably is 
> in the kernel.

But it really isn't, as the firmware kit has proven...

thanks,

greg k-h
