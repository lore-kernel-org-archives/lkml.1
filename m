Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbXCYAit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbXCYAit (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 20:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXCYAid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 20:38:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59372 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbXCYAic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 20:38:32 -0400
Date: Sat, 24 Mar 2007 17:35:57 -0700
From: Greg KH <greg@kroah.com>
To: Ryan Hope <rmh3093@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: pciehp: Cannot get control of hotplug hardware
Message-ID: <20070325003557.GA22484@kroah.com>
References: <48f7fe350703100755i75d2a56al981da1fbda645ddc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f7fe350703100755i75d2a56al981da1fbda645ddc@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 10:55:16AM -0500, Ryan Hope wrote:
> Ever since I started playing with suspend I started turning on PCI Hot
> Plug support.... since then I have been seeing messages like whats
> below from dmesg.... I'm not exactly sure how this actually impacts me
> if it does at all. I just thought it didn't look exactly right so I
> wanted to inquire about it. Does anyone know what is going on here?
> 
> -Ryan
> 
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> decode_hpp: Could not get hotplug parameters. Use defaults
> pciehp: HPC vendor_id 8086 device_id 27d0 ss_vid 0 ss_did 0
> Evaluate _OSC Set fails. Status = 0x0005
> Evaluate _OSC Set fails. Status = 0x0005
> pciehp: Cannot get control of hotplug hardware for pci 0000:00:1c.0

Your pci express hotplug controller does not support the proper hotplug
capabilities.  It's probably a bios issue as Windows doesn't support
this just yet (I think Vista now does), so those functions were usually
never tested.

You should be able to just ignore them, unless you want to use your pci
express hotplug functionality.  What kind of hardware is this, a laptop
with expresscard?  Or something else?

thanks,

greg k-h
