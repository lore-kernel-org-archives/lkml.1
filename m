Return-Path: <linux-kernel-owner+w=401wt.eu-S1761597AbXKNAKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761597AbXKNAKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbXKNAKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:10:12 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:49298 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbXKNAKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:10:10 -0500
Date: Tue, 13 Nov 2007 17:10:08 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <gregkh@suse.de>, Rick Jones <rick.jones2@hp.com>,
       Greg KH <greg@kroah.com>, Alex Chiang <achiang@hp.com>, lenb@kernel.org,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071114001008.GQ17785@parisc-linux.org>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113202154.GA22812@ldl.fc.hp.com> <20071113202632.GA3227@kroah.com> <473A2A61.7030303@hp.com> <20071113225605.GA2589@suse.de> <20071113230400.GP17785@parisc-linux.org> <20071113153314.ba46cdf0.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113153314.ba46cdf0.kristen.c.accardi@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 03:33:14PM -0800, Kristen Carlson Accardi wrote:
> As far as being able to retrieve the slot number (which it seemed from
> the HP manageablity application perspective is the goal here), that
> information is available from userspace as well for at least standard PCI
> and pcie based systems for occupied slots.  For standard pci, you have
> to make something up anyway - for shpchp we just use an incremental 
> number and combine it with the bus number to represent the slot.  For
> pcie, you can get this info from the slot capabilities register.

Ummm ... that's not what the /spec/ says.  I've never worked on any shpc
machines, but the shpc driver reads the slot values from the SLOT_CONFIG
register, just like the spec says to.

I don't understand how you're supposed to get the slot number for
standard PCI for occupied slots.  Could you explain?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
