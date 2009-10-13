Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbZJMDUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbZJMDUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 23:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZJMDUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 23:20:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56072 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZJMDUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 23:20:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AD3F1D4.1000006@jp.fujitsu.com>
Date: Tue, 13 Oct 2009 12:19:48 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
References: <20091012120620.GG9228@kernel.dk>
In-Reply-To: <20091012120620.GG9228@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
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
> 

Could you give me the result of "ls -lR /sys/bus/pci/slots/"
after loading pciehp?

Thanks,
Kenji Kaneshige


