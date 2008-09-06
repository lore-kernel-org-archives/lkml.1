Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbYIFVSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbYIFVSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 17:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYIFVSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 17:18:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:62463 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbYIFVSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 17:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=arAbMKcFkAUQo8Y/8yJ4hSY0Cv/swYNuKTCE6ojbP/yt5sPpMa89ZqbSIKDuzghxSt
         6WLJplARW3a/O5Ko/Ht8jLvALbdk8eyWFK9KBmp8Q3TFMAXhjyaG8Dk4uTYCMrK8Q1pH
         MIrKU8icNABp5n7WcvfGhYOX+UIwou5VZOx1E=
Message-ID: <86802c440809061418n30ac986bj1e842bfb4beae954@mail.gmail.com>
Date: Sat, 6 Sep 2008 14:18:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: hotplug create_slot hang
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
In-Reply-To: <20080906124401.e0b21253.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440809061015v21b6c1eat8718618a6ae25e47@mail.gmail.com>
	 <20080906124401.e0b21253.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2008 at 12:44 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 6 Sep 2008 10:15:03 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>> calling  pci_hotplug_init+0x0/0x1d
>> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
>> initcall pci_hotplug_init+0x0/0x1d returned 0 after 11 msecs
>>
>> calling  acpiphp_init+0x0/0x5f
>> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>> decode_hpp: Could not get hotplug parameters. Use defaults
>> pci_create_slot: created pci_slot on 0000:07:00
>> acpiphp: Slot [1] registered
>> decode_hpp: Could not get hotplug parameters. Use defaults
>> pci_create_slot: created pci_slot on 0000:0d:00
>> acpiphp: Slot [2] registered
>> initcall acpiphp_init+0x0/0x5f returned 0 after 105 msecs
>>
>> calling  pcied_init+0x0/0x7b
>> pciehp: HPC vendor_id 8086 device_id 340a ss_vid 0 ss_did 0
>> pci_create_slot: inc refcount to 2 on 0000:07:00
>> pci_destroy_slot: dec refcount to 1 on 0000:07:00
>> pciehp: pci_hp_register failed with error -16
>> pciehp: pciehp: slot already registered by another hotplug driver
>

current tip/master

two days ago works.

YH
