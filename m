Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbZJLPBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbZJLPBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756663AbZJLPBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:01:15 -0400
Received: from rtr.ca ([76.10.145.34]:35229 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716AbZJLPBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:01:14 -0400
Message-ID: <4AD34494.7020602@rtr.ca>
Date: Mon, 12 Oct 2009 11:00:36 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
References: <20091012120620.GG9228@kernel.dk> <20091012145254.GA1517@kroah.com> <20091012145700.GJ9228@kernel.dk>
In-Reply-To: <20091012145700.GJ9228@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Oct 12 2009, Greg KH wrote:
>> On Mon, Oct 12, 2009 at 02:06:20PM +0200, Jens Axboe wrote:
>>> Hi,
>>>
>>> I'm trying to get pci-express hotplug working in a box here. I don't
>>> really care about the hotplug aspect, I just want the darn pci-e slots
>>> that are designated hotplug slots to actually WORK. When I load pciehp,
>>> I get:
>>>
>>> Firmware did not grant requested _OSC control
>>> Firmware did not grant requested _OSC control
>>> Firmware did not grant requested _OSC control
>>> Firmware did not grant requested _OSC control
>>> pciehp 0000:00:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid 0 ss_did 0
>>> pciehp 0000:00:05.0:pcie04: service driver pciehp loaded
>>> Firmware did not grant requested _OSC control
>>> pciehp 0000:00:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
>>> pciehp 0000:00:07.0:pcie04: service driver pciehp loaded
>>> Firmware did not grant requested _OSC control
>>> pciehp 0000:80:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
>>> pciehp 0000:80:07.0:pcie04: service driver pciehp loaded
>>> pciehp 0000:80:09.0:pcie04: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
>>> pciehp 0000:80:09.0:pcie04: service driver pciehp loaded
>>> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
>>>
>>> and the devices in the hotplug slots stay off. Is this an ACPI/bios
>>> issue? How can I debug this?
>> Can you try the acpiphp driver instead?  That's usually the driver you
>> want to use for "modern" systems (i.e. anything made in the past 5
>> years.)
> 
> I should have mentioned that I tried that too. It doesn't complain, but
> I don't see my cards anywhere afterwards. I'm a hotplug newbie, do I
> need to do anything else?
 
Tried this yet:

   options pciehp pciehp_force=1

??
