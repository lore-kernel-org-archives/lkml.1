Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbZJLMG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbZJLMG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZJLMG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:06:57 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56817 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbZJLMG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:06:57 -0400
Date: Mon, 12 Oct 2009 14:06:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org
Subject: pci-express hotplug
Message-ID: <20091012120620.GG9228@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to get pci-express hotplug working in a box here. I don't
really care about the hotplug aspect, I just want the darn pci-e slots
that are designated hotplug slots to actually WORK. When I load pciehp,
I get:

Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
pciehp 0000:00:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid 0 ss_did 0
pciehp 0000:00:05.0:pcie04: service driver pciehp loaded
Firmware did not grant requested _OSC control
pciehp 0000:00:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
pciehp 0000:00:07.0:pcie04: service driver pciehp loaded
Firmware did not grant requested _OSC control
pciehp 0000:80:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
pciehp 0000:80:07.0:pcie04: service driver pciehp loaded
pciehp 0000:80:09.0:pcie04: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
pciehp 0000:80:09.0:pcie04: service driver pciehp loaded
pciehp: PCI Express Hot Plug Controller Driver version: 0.4

and the devices in the hotplug slots stay off. Is this an ACPI/bios
issue? How can I debug this?

-- 
Jens Axboe

