Return-Path: <linux-kernel-owner+w=401wt.eu-S966354AbXJPWR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966354AbXJPWR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965652AbXJPWRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:17:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57606 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965532AbXJPWRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:17:15 -0400
Date: Tue, 16 Oct 2007 15:03:54 -0700
From: Greg KH <greg@kroah.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       pcihpd-discuss@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix PCIe hotplug for Dell notebook ExpressCard slots
Message-ID: <20071016220354.GA22828@kroah.com>
References: <20071016084634.8a0d695a.kristen.c.accardi@intel.com> <47150565.5090102@rtr.ca> <20071016114328.a96e8bcb.kristen.c.accardi@intel.com> <47150982.6050102@rtr.ca> <471509FE.7080505@rtr.ca> <47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com> <4715217D.2000803@rtr.ca> <20071016214143.GC21815@kroah.com> <471533AF.60100@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471533AF.60100@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 05:57:03PM -0400, Mark Lord wrote:
> Fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks
> in conjunction with modparam of pciehp_force=1.
>
> The PCIe Hotplug driver has two shortcomings when used on Dell notebooks
> which lack ACPI BIOS support for PCIe hotplug:

Wait, Dell explicitly says that pci hotplug of express cards is not
supported and is broken on these laptops.  This is because the version
of Windows they support on these machines also does not support
hotplugging these devices.

The current code works just fine on hardware that actually supports this
kind of functionality, as per the proper specs and requirements for this
feature.

So why try to go through these gyrations for hardware that is explicitly
broken?

thanks,

greg k-h
