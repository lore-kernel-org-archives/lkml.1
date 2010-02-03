Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab0BCNsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 08:48:00 -0500
Received: from mbox2.netikka.net ([213.250.81.203]:36969 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab0BCNr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 08:47:58 -0500
Message-ID: <4B697E8A.9000806@mandriva.org>
Date: Wed, 03 Feb 2010 15:47:54 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100122 Mandriva/3.0.1-2mdv2010.1 (2010.1) Thunderbird/3.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: linux-acpi@vger.kernel.org, venkatesh.pallipadi@intel.com
Subject: Re: WARNING: at arch/x86/kernel/hpet.c:404 hpet_next_event+0x7d/0x90()
References: <4B68462F.7050203@mandriva.org>
In-Reply-To: <4B68462F.7050203@mandriva.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02.02.2010 17:35, Thomas Backlund skrev:
> This is still happening on 2.6.33-rc6-git1 running x86_64 kernel
>
> HW is a Core i7-860 on an ASUS P7P55D Deluxe m/b
>
> I've seen this since atleast 2.6.31 series kernels...
>
> I seem to have seen other reports about this, and some errata fix &
> patch for this, but I cant find it right now...
>

Hi Venki,

Since this issue is the same as reported here:
http://marc.info/?l=linux-kernel&m=125769096017449&w=2
[2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390]

and you stated here:
http://marc.info/?l=linux-kernel&m=125849385330302&w=2

that you didn't have a ETA for the errata to be published...

Now, it's about 2.5 months later, and the warning is still there,
so... Is there any updates to this, or should I just silence the
warning with the patch you posted for test...

--
Thomas

>> [ 11.668507] ------------[ cut here ]------------
>> [ 11.668514] WARNING: at arch/x86/kernel/hpet.c:404
>> hpet_next_event+0x7d/0x90()
>> [ 11.668516] Hardware name: System Product Name
>> [ 11.668517] hpet: compare register read back failed.
>> [ 11.668518] Modules linked in: processor(+) iTCO_vendor_support
>> button pata_jmicron dm_snapshot dm_zero dm_mirror dm_region_hash
>> dm_log dm_mod ata_piix ahci libata sd_mod scsi_mod crc_t10dif ext4
>> jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd usbhid hid usbcore
>> [ 11.668530] Pid: 0, comm: swapper Not tainted
>> 2.6.33-tmb-desktop-0.rc6.1.2mdv #1
>> [ 11.668532] Call Trace:
>> [ 11.668536] [<ffffffff810400a8>] warn_slowpath_common+0x78/0xb0
>> [ 11.668538] [<ffffffff8104013c>] warn_slowpath_fmt+0x3c/0x40
>> [ 11.668541] [<ffffffff81022b5d>] hpet_next_event+0x7d/0x90
>> [ 11.668543] [<ffffffff81022b8b>] hpet_legacy_next_event+0xb/0x10
>> [ 11.668547] [<ffffffff810642d9>] clockevents_program_event+0x59/0xa0
>> [ 11.668549] [<ffffffff81065740>] tick_dev_program_event+0x40/0xd0
>> [ 11.668553] [<ffffffff810650c6>]
>> tick_broadcast_oneshot_control+0x116/0x120
>> [ 11.668556] [<ffffffff810648f5>] tick_notify+0x315/0x450
>> [ 11.668560] [<ffffffff811d537c>] ? acpi_hw_read+0x51/0x58
>> [ 11.668563] [<ffffffff8105ce57>] notifier_call_chain+0x47/0x90
>> [ 11.668566] [<ffffffff8105cf41>] raw_notifier_call_chain+0x11/0x20
>> [ 11.668569] [<ffffffff810640e2>] clockevents_notify+0x32/0x170
>> [ 11.668575] [<ffffffffa0196f28>]
>> lapic_timer_state_broadcast+0x41/0x43 [processor]
>> [ 11.668580] [<ffffffffa0197436>] acpi_idle_enter_bm+0x15c/0x28a
>> [processor]
>> [ 11.668585] [<ffffffff8125bccb>] cpuidle_idle_call+0x9b/0x100
>> [ 11.668589] [<ffffffff81001933>] cpu_idle+0x63/0xc0
>> [ 11.668592] [<ffffffff8130a47d>] start_secondary+0x18b/0x18f
>> [ 11.668595] ---[ end trace 34f793092b044afa ]---
>
> --
> Thomas
>

