Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbXKMXgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbXKMXgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbXKMXgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:36:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:10113 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbXKMXgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:36:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,412,1188802800"; 
   d="scan'208";a="270084821"
Date: Tue, 13 Nov 2007 15:33:14 -0800
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <gregkh@suse.de>, Rick Jones <rick.jones2@hp.com>,
       Greg KH <greg@kroah.com>, Alex Chiang <achiang@hp.com>, lenb@kernel.org,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-Id: <20071113153314.ba46cdf0.kristen.c.accardi@intel.com>
In-Reply-To: <20071113230400.GP17785@parisc-linux.org>
References: <20071113000853.GA13341@ldl.fc.hp.com>
	<20071113170129.GA20185@kroah.com>
	<20071113202154.GA22812@ldl.fc.hp.com>
	<20071113202632.GA3227@kroah.com>
	<473A2A61.7030303@hp.com>
	<20071113225605.GA2589@suse.de>
	<20071113230400.GP17785@parisc-linux.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 16:04:00 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Tue, Nov 13, 2007 at 02:56:05PM -0800, Greg KH wrote:
> > Why not just use the code in the linux firmware kit that does this
> > already today from userspace (thanks to Kristen for pointing this out to
> > me on irc.)?
> 
> So then we have something that works on ACPI-based machines.  Who will
> add support for all the other kinds of firmware and non-firmware based
> slots?
> 

As far as being able to retrieve the slot number (which it seemed from
the HP manageablity application perspective is the goal here), that
information is available from userspace as well for at least standard PCI
and pcie based systems for occupied slots.  For standard pci, you have
to make something up anyway - for shpchp we just use an incremental 
number and combine it with the bus number to represent the slot.  For
pcie, you can get this info from the slot capabilities register.
