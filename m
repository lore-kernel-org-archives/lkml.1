Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbZBFUhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbZBFUhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 15:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZBFUhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 15:37:05 -0500
Received: from bay0-omc2-s24.bay0.hotmail.com ([65.54.246.160]:57635 "EHLO
	bay0-omc2-s24.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbZBFUhD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 15:37:03 -0500
Message-ID: <BAY111-W508641BB57F73F5040304688C10@phx.gbl>
X-Originating-IP: [128.107.248.220]
From: Krishna Kothapalli <krishna_sunitha@hotmail.com>
To: <kaneshige.kenji@jp.fujitsu.com>
CC: <ebiederm@xmission.com>, <linux-pci@vger.kernel.org>,
       <jbarnes@virtuousgeek.org>, <achiang@hp.com>, <djwong@us.ibm.com>,
       <xyzzy@speakeasy.org>, <linux-kernel@vger.kernel.org>
Subject: RE: Q: state of pci express hotplug
Date: Fri, 6 Feb 2009 15:37:01 -0500
Importance: Normal
In-Reply-To: <498A8A52.9030606@jp.fujitsu.com>
References: <m1fxj06js8.fsf@fess.ebiederm.org>
 <4986581F.7060704@jp.fujitsu.com>
   <BAY111-W15F61DA9CA66E14686D5F688C50@phx.gbl>
   <49879508.4090801@jp.fujitsu.com>
   <BAY111-W3692AA5F9F7896AA447A1F88C20@phx.gbl>
 <BAY111-W9013DA1F63973F9E7F8DF88C30@phx.gbl>
 <49892CDE.9040305@jp.fujitsu.com>
 <BAY111-W205B70ED6B226F2F9D8E2088C30@phx.gbl>
 <498A2C90.2000208@jp.fujitsu.com>
 <BAY111-W332E2827777D42F10C311E88C00@phx.gbl>
 <498A8A52.9030606@jp.fujitsu.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 06 Feb 2009 20:37:02.0293 (UTC) FILETIME=[AA756050:01C9889A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> Kenji Kaneshige
> Thank you for the information. From the information, I understood
> both acpiphp and pciehp handles the same slot, and failed powering
> on the slot because those drivers detected adapter card didn't
> present or MRL opened. But I still don't know why. Could you send
> the following addtional information?

Apologize for the delay. I tried hotplug of PCI express card on a vendor box (running 2.6.18.x) with PCI express slot.
It looked a lot better. Here is dmesg output as soon a I hotplug and the device shows up in lspci  !!!

So I guess my mother board PCIe slot or BIOS is bad and looking for a looking for a low cost motherboard with working hotplug PCIe slot :)

pciehp: pcie_isr: intr_loc 8
pciehp: pcie_isr: hp_register_read_word SLOT_CTRL with value 28
pciehp: pcie_isr: hp_register_read_word SLOT_STATUS with value 48
pciehp: pciehp:  Presence/Notify input change.
pciehp: Card present on Slot(0003_0003)
pciehp: pcie_isr: Unmask Hot-plug Interrupt Enable
pciehp: event_thread woken finished = 0
pciehp: Surprise Removal
pciehp: hpc_get_power_status: SLOT_CTRL 58 value read 8
pciehp: hpc_get_attention_status: SLOT_CTRL 58, value read 8
pciehp: !!!!event_thread sleeping
pciehp: event_thread woken finished = 0
pciehp: pciehp_surprise_rm_thread: adding bus:device(3:0)
pciehp: board_added: slot device, slot offset, hp slot = 0, 0 ,0
pciehp: pcie_isr: hp_register_write_word SLOT_STATUS with value 1f
pciehp: hpc_check_lnk_status: lnk_status = 3011
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 177
PCI: Setting latency timer of device 0000:03:00.0 to 64
ACPI: PCI interrupt for device 0000:03:00.0 disabled
pciehp: hpc_get_power_status: SLOT_CTRL 58 value read 28
pciehp: hpc_get_attention_status: SLOT_CTRL 58, value read 28
pciehp: !!!!event_thread sleeping


Thanks much for your all help. 

Thanks,
Krishna

_________________________________________________________________
Windows Live™: E-mail. Chat. Share. Get more ways to connect. 
http://windowslive.com/online/hotmail?ocid=TXT_TAGLM_WL_HM_AE_Faster_022009