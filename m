Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYIFRPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYIFRPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYIFRPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:15:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:46224 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbYIFRPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:15:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=S+X5NtGC+5jZ+CidRhRCdux9d7/hK4vUPtlyM4bNX47fJWW0Jb1JR1mxpO+pHdCnzS
         VvfKMjksCmNufwRF7ZYDBYVQrOsvgwPLPlSLSxrfdWValJ9ksJysKKlaM9XUv/X/3Yrl
         wUDIrCZ5NHyiWMAALEV1f1vChxqtacoDSH+k0=
Message-ID: <86802c440809061015v21b6c1eat8718618a6ae25e47@mail.gmail.com>
Date: Sat, 6 Sep 2008 10:15:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: hotplug create_slot hang
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

calling  pci_hotplug_init+0x0/0x1d
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall pci_hotplug_init+0x0/0x1d returned 0 after 11 msecs

calling  acpiphp_init+0x0/0x5f
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
decode_hpp: Could not get hotplug parameters. Use defaults
pci_create_slot: created pci_slot on 0000:07:00
acpiphp: Slot [1] registered
decode_hpp: Could not get hotplug parameters. Use defaults
pci_create_slot: created pci_slot on 0000:0d:00
acpiphp: Slot [2] registered
initcall acpiphp_init+0x0/0x5f returned 0 after 105 msecs

calling  pcied_init+0x0/0x7b
pciehp: HPC vendor_id 8086 device_id 340a ss_vid 0 ss_did 0
pci_create_slot: inc refcount to 2 on 0000:07:00
pci_destroy_slot: dec refcount to 1 on 0000:07:00
pciehp: pci_hp_register failed with error -16
pciehp: pciehp: slot already registered by another hotplug driver
