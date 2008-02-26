Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbYBZFWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbYBZFWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 00:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYBZFWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 00:22:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44568 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbYBZFWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 00:22:17 -0500
Date: Mon, 25 Feb 2008 20:54:41 -0800
From: Greg KH <greg@kroah.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: pcihpd-discuss@lists.sourceforge.net,
       Kristen Accardi <kristen.c.accardi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Pcihpd-discuss] 2.6.25-rc3 -- SHPC hotplug driver - very long
	timeouts?
Message-ID: <20080226045441.GA4469@kroah.com>
References: <a44ae5cd0802252030m77bb2b9p7de615a9f863b81d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0802252030m77bb2b9p7de615a9f863b81d@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:30:03PM -0500, Miles Lane wrote:
> Hello,
> 
> When I booted this kernel, the process was hugely delayed in shpchp.
> I don't think I usually build this driver, so perhaps this is its
> standard behavior when the hardware is missing, or some such?  Or, is
> this a bug in the driver?  Either way, the timeouts seem excessively
> long.
> 
> [   24.471137] CPA self-test:
> [   24.474565]  4k 8192 large 216 gb 0 x 8408[c0000000-f7fff000] miss 0
> [   24.491200]  4k 196608 large 32 gb 0 x 196640[c0000000-f7fff000] miss 0
> [   24.503549]  4k 196608 large 32 gb 0 x 196640[c0000000-f7fff000] miss 0
> [   24.504440] ok.
> [   42.209886] shpchp: gave up waiting for init of module pci_hotplug.
> [   42.213190] shpchp: Unknown symbol acpi_run_oshp
> [   72.052520] shpchp: gave up waiting for init of module pci_hotplug.
> [   72.055826] shpchp: Unknown symbol pci_hp_change_slot_info
> [  101.931221] shpchp: gave up waiting for init of module pci_hotplug.
> [  101.934526] shpchp: Unknown symbol pci_hp_register
> [  131.789952] shpchp: gave up waiting for init of module pci_hotplug.
> [  131.793258] shpchp: Unknown symbol pci_hp_deregister
> [  161.683306] shpchp: gave up waiting for init of module pci_hotplug.
> [  161.686611] shpchp: Unknown symbol acpi_get_hp_params_from_firmware
> [  162.935681] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4

This is not a hotplug-specific bug, but rather one in the module loading
logic.  People who had seen this on -rc1 said it went away in -rc3.  I
suggest poking Rusty about it...

thanks,

greg k-h
