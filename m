Return-Path: <linux-kernel-owner+w=401wt.eu-S932476AbZJLO4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbZJLO4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbZJLO4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:56:11 -0400
Received: from kroah.org ([198.145.64.141]:39840 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428AbZJLO4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:56:10 -0400
Date: Mon, 12 Oct 2009 07:52:54 -0700
From: Greg KH <greg@kroah.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091012145254.GA1517@kroah.com>
References: <20091012120620.GG9228@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012120620.GG9228@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 02:06:20PM +0200, Jens Axboe wrote:
> Hi,
> 
> I'm trying to get pci-express hotplug working in a box here. I don't
> really care about the hotplug aspect, I just want the darn pci-e slots
> that are designated hotplug slots to actually WORK. When I load pciehp,
> I get:
> 
> Firmware did not grant requested _OSC control
> Firmware did not grant requested _OSC control
> Firmware did not grant requested _OSC control
> Firmware did not grant requested _OSC control
> pciehp 0000:00:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid 0 ss_did 0
> pciehp 0000:00:05.0:pcie04: service driver pciehp loaded
> Firmware did not grant requested _OSC control
> pciehp 0000:00:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
> pciehp 0000:00:07.0:pcie04: service driver pciehp loaded
> Firmware did not grant requested _OSC control
> pciehp 0000:80:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
> pciehp 0000:80:07.0:pcie04: service driver pciehp loaded
> pciehp 0000:80:09.0:pcie04: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
> pciehp 0000:80:09.0:pcie04: service driver pciehp loaded
> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> 
> and the devices in the hotplug slots stay off. Is this an ACPI/bios
> issue? How can I debug this?

Can you try the acpiphp driver instead?  That's usually the driver you
want to use for "modern" systems (i.e. anything made in the past 5
years.)

thanks,

greg k-h
