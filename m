Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbYLYDvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbYLYDvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 22:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYLYDvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 22:51:35 -0500
Received: from adsl100-93.ath.forthnet.gr ([79.103.127.93]:43443 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYLYDve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 22:51:34 -0500
Message-ID: <4953032D.4040106@asyr.hopto.org>
Date: Thu, 25 Dec 2008 05:51:09 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081222)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Sil 3132 SATA II express card
References: <f7848160812241827s39063b23t6a9eac12fdec6708@mail.gmail.com>
In-Reply-To: <f7848160812241827s39063b23t6a9eac12fdec6708@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 12/25/2008 04:27 AM Parag Warudkar wrote the following:
> Thanasis <thanasis <at> asyr.hopto.org> writes:
> 
>> I have compiled in kernel (2.6.27) support for Sil 3132:
>> CONFIG_SATA_SIL24=y
>>
>> When I insert the card in the laptop's slot, dmesg shows nothing new.
>> Is this normal?
>>
> 
> Last time I tried that I had to modprobe the pcie hotplug module
> (pciehp?) before inserting the card and even then it only worked some
> times.
> 
> If you boot with the card plugged in that should work - I haven't
> tried lately but pciehp was flaky on my hardware (MacBook  Pro).
> 

That is exactly what happens to my hw too. :-\

System Information
	Manufacturer: Gateway
	Product Name: T-1625


 # grep -i hotplug .config
CONFIG_HOTPLUG=y
# Memory hotplug is currently incompatible with Software Suspend
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"


# lsmod |grep pci
pciehp                 32156  0
