Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYJOQv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYJOQv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 12:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYJOQvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 12:51:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60404 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYJOQvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 12:51:33 -0400
Message-ID: <48F61F4B.9040709@jp.fujitsu.com>
Date: Thu, 16 Oct 2008 01:50:19 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6-resend 00/17] PCI: let the core manage slot names
References: <20081014072311.24319.27334.stgit@bob.kio>
In-Reply-To: <20081014072311.24319.27334.stgit@bob.kio>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested the set of patches using pci_slot, pciehp and shpchp
driver. Looks good.

Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>


Alex Chiang wrote:
> Sorry, I had a botchup with stgit (not sure why it did not send out
> all the patches in my series).
> 
> This thread should contain all 17 patches in the series.
> 
> Thanks.
> 
> /ac
> 
> ---
> 
> Alex Chiang (16):
>       PCI Hotplug: fakephp: add duplicate slot name debugging
>       PCI: Hotplug core: remove 'name'
>       PCI: shcphp: remove 'name' parameter
>       PCI: SGI Hotplug: stop managing bss_hotplug_slot->name
>       PCI: rpaphp: kmalloc/kfree slot->name directly
>       PCI: pciehp: remove 'name' parameter
>       PCI: ibmphp: stop managing hotplug_slot->name
>       PCI: fakephp: remove 'name' parameter
>       PCI: cpqphp: stop managing hotplug_slot->name
>       PCI: cpci_hotplug: stop managing hotplug_slot->name
>       PCI: acpiphp: remove 'name' parameter
>       PCI, PCI Hotplug: introduce slot_name helpers
>       PCI: prevent duplicate slot names
>       PCI: update pci_create_slot() to take a 'hotplug' param
>       PCI: rename pci_update_slot_number to pci_renumber_slot
>       PCI Hotplug core: add 'name' param pci_hp_register interface
> 
> Kenji Kaneshige (1):
>       PCI Hotplug: serialize pci_hp_register and pci_hp_deregister
> 
> 
>  drivers/acpi/pci_slot.c                 |    2 
>  drivers/pci/hotplug/acpiphp.h           |    9 +-
>  drivers/pci/hotplug/acpiphp_core.c      |   32 +++---
>  drivers/pci/hotplug/cpci_hotplug.h      |    6 +
>  drivers/pci/hotplug/cpci_hotplug_core.c |   75 ++++++---------
>  drivers/pci/hotplug/cpci_hotplug_pci.c  |    4 -
>  drivers/pci/hotplug/cpqphp.h            |   13 +--
>  drivers/pci/hotplug/cpqphp_core.c       |   43 ++++----
>  drivers/pci/hotplug/fakephp.c           |   26 +++--
>  drivers/pci/hotplug/ibmphp.h            |    5 -
>  drivers/pci/hotplug/ibmphp_ebda.c       |   19 +---
>  drivers/pci/hotplug/pci_hotplug_core.c  |   64 ++++--------
>  drivers/pci/hotplug/pciehp.h            |    9 +-
>  drivers/pci/hotplug/pciehp_core.c       |   49 +++------
>  drivers/pci/hotplug/pciehp_ctrl.c       |   53 ++++++----
>  drivers/pci/hotplug/pciehp_hpc.c        |    1 
>  drivers/pci/hotplug/rpaphp_slot.c       |   10 +-
>  drivers/pci/hotplug/sgi_hotplug.c       |   18 +--
>  drivers/pci/hotplug/shpchp.h            |    9 +-
>  drivers/pci/hotplug/shpchp_core.c       |   52 ++++------
>  drivers/pci/hotplug/shpchp_ctrl.c       |   48 +++++----
>  drivers/pci/slot.c                      |  160 +++++++++++++++++++++++--------
>  include/linux/pci.h                     |   10 ++
>  include/linux/pci_hotplug.h             |   11 +-
>  24 files changed, 382 insertions(+), 346 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


