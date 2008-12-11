Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbYLKOSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbYLKOSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 09:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbYLKOSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 09:18:01 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:63442 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbYLKOSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 09:18:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=TxuWLCjbPZBD40wfjzgpRRLEO6GKy+5Y8nbfWINeAq0DC/fUo9EBHOnpKXDdqJhTlo
         RmG7aX+SQdHXfz3KNB8DeLAnqf7TYcK1xc2EDocsAJoSFlv89X8FJxjFZWwa2c6OlTXn
         mgqICDHxcGf2ssg15rX8Zq9coBEgoBWccKL+4=
Message-ID: <494182DC.7080808@gmail.com>
Date: Thu, 11 Dec 2008 22:15:08 +0100
From: jan sonnek <ha2nny@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Warning -mmc card when Suspend
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I suspend and then wake up my notebook I get this warning.

[15409.820484] Broken read from PCI device 0000:05:01.4
[15409.820493] ------------[ cut here ]------------
[15409.820497] WARNING: at drivers/pci/pci.c:747 pci_save_state+0x50/0x189()
[15409.820502] Hardware name: F3F
[15409.820506] Modules linked in: coretemp hwmon ipv6 iwl3945 rfkill 
mac80211 ohci1394 ieee1394 sdhci_pci sdhci cfg80211 mmc_core ricoh_mmc 
sr_mod cdrom sg battery
[15409.820530] Pid: 7599, comm: pm-suspend Tainted: G        W 
2.6.28-rc7-mm1-hanny #4
[15409.820536] Call Trace:
[15409.820543]  [<c01260d6>] warn_slowpath+0x76/0xad
[15409.820552]  [<c0175501>] ? constant_test_bit+0x9/0x20
[15409.820559]  [<c0103847>] ? ftrace_call+0x5/0x8
[15409.820565]  [<c0103847>] ? ftrace_call+0x5/0x8
[15409.820572]  [<c0143448>] ? test_ti_thread_flag+0x8/0x10
[15409.820579]  [<c0376d00>] ? _spin_unlock_irq+0x18/0x2a
[15409.820586]  [<c0143448>] ? test_ti_thread_flag+0x8/0x10
[15409.820592]  [<c0376d32>] ? _spin_unlock_irqrestore+0x20/0x2b
[15409.820598]  [<c01f9431>] ? pci_bus_read_config_dword+0x5c/0x68
[15409.820605]  [<c01fc2a6>] pci_save_state+0x50/0x189
[15409.820612]  [<c01fe1d4>] pci_legacy_suspend+0x3c/0x52
[15409.820618]  [<c01fe326>] pci_pm_suspend+0x62/0x77
[15409.820625]  [<c02622d0>] pm_op+0x4a/0xc4
[15409.820631]  [<c0262993>] device_suspend+0x361/0x469
[15409.820637]  [<c0147710>] suspend_devices_and_enter+0x3d/0x114
[15409.820644]  [<c01479f0>] enter_state+0x1b7/0x23e
[15409.820649]  [<c0147b0b>] state_store+0x94/0xa7
[15409.820655]  [<c0147a77>] ? state_store+0x0/0xa7
[15409.820662]  [<c01f01d5>] kobj_attr_store+0x1a/0x22
[15409.820668]  [<c01b2a1b>] sysfs_write_file+0xb9/0xe4
[15409.820674]  [<c01b2962>] ? sysfs_write_file+0x0/0xe4
[15409.820681]  [<c017bae7>] vfs_write+0x81/0xb2
[15409.820686]  [<c017bbbb>] sys_write+0x40/0x65
[15409.820692]  [<c0103031>] sysenter_do_call+0x12/0x25
[15409.820698] ---[ end trace 71ce89e40e3c7ca1 ]---

When I insert my SD card the same problem I get and Registre dump, more 
in my dmesg in attachement.

05:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 
ff) (prog-if ff)
         !!! Unknown header type 7f

[16480.579435] Disabling non-boot CPUs ...
[16480.625957] mmc0: Controller never released inhibit bit(s).
[16480.625957] sdhci: ============== REGISTER DUMP ==============
[16480.625957] sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
[16480.625957] sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
[16480.625957] sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
[16480.625957] sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
[16480.625957] sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
[16480.625957] sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
[16480.625957] sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
[16480.625957] sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
[16480.625957] sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
[16480.625957] sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
[16480.625957] sdhci: ===========================================
...

Thanks,

-js


