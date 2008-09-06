Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbYIFTo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbYIFTo2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 15:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYIFToT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 15:44:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367AbYIFToS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 15:44:18 -0400
Date: Sat, 6 Sep 2008 12:44:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: hotplug create_slot hang
Message-Id: <20080906124401.e0b21253.akpm@linux-foundation.org>
In-Reply-To: <86802c440809061015v21b6c1eat8718618a6ae25e47@mail.gmail.com>
References: <86802c440809061015v21b6c1eat8718618a6ae25e47@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Sep 2008 10:15:03 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> calling  pci_hotplug_init+0x0/0x1d
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> initcall pci_hotplug_init+0x0/0x1d returned 0 after 11 msecs
> 
> calling  acpiphp_init+0x0/0x5f
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> decode_hpp: Could not get hotplug parameters. Use defaults
> pci_create_slot: created pci_slot on 0000:07:00
> acpiphp: Slot [1] registered
> decode_hpp: Could not get hotplug parameters. Use defaults
> pci_create_slot: created pci_slot on 0000:0d:00
> acpiphp: Slot [2] registered
> initcall acpiphp_init+0x0/0x5f returned 0 after 105 msecs
> 
> calling  pcied_init+0x0/0x7b
> pciehp: HPC vendor_id 8086 device_id 340a ss_vid 0 ss_did 0
> pci_create_slot: inc refcount to 2 on 0000:07:00
> pci_destroy_slot: dec refcount to 1 on 0000:07:00
> pciehp: pci_hp_register failed with error -16
> pciehp: pciehp: slot already registered by another hotplug driver

which kernel version is this?
