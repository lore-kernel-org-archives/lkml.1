Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbYFFKr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbYFFKr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 06:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYFFKrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 06:47:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755153AbYFFKrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 06:47:40 -0400
Date: Fri, 6 Jun 2008 03:47:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?Q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
Message-Id: <20080606034738.9835782d.akpm@linux-foundation.org>
In-Reply-To: <200806060039.48488.m1k0@wp.pl>
References: <200806060039.48488.m1k0@wp.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-wireless)

On Fri, 6 Jun 2008 00:39:48 +0200 Micha__ Kud__a <michal.kudla@gmail.com> wrote:

> Hello,
> according to  http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html
> [1.] One line summary of the problem: 
> [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23

Thanks.  Do you know if it worked in 2.6.24 or 2.6.25?

> [2.] Full description of the problem/report:
> linux: gentoo
> kernel vanilla-sources-2-6-26-rc5
> laptop: Asus S96S
> WiFi: intel 4695
> WiFi not working.
> In the same config, but with gentoo-sources-2.6.23 WiFi working well.
> 
> dmesg - 2.6.23
> iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.25ds
> iwl4965: Copyright(c) 2003-2007 Intel Corporation
> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 21
> PCI: Setting latency timer of device 0000:04:00.0 to 64
> iwl4965: Detected Intel Wireless WiFi Link 4965AGN
> wmaster0: Selected rate control algorithm 'iwl-4965-rs'
> ...
> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 21
> PM: Writing back config space on device 0000:04:00.0 at offset 1 (was 100102, 
> writing 100106)
> iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> r8169: eth0: link up
> wlan0: Initial auth_alg=0
> wlan0: authenticate with AP 00:01:e3:06:00:35
> wlan0: RX authentication from 00:01:e3:06:00:35 (alg=0 transaction=2 status=0)
> wlan0: authenticated
> wlan0: associate with AP 00:01:e3:06:00:35
> wlan0: authentication frame received from 00:01:e3:06:00:35, but not in 
> authenticate state - ignored
> wlan0: RX AssocResp from 00:01:e3:06:00:35 (capab=0x11 status=0 aid=2)
> wlan0: associated
> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> wlan0: no IPv6 routers present
> 
> dmesg 2.6.26
> iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.26kds
> iwl4965: Copyright(c) 2003-2008 Intel Corporation
> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> PCI: Setting latency timer of device 0000:04:00.0 to 64
> iwl4965: Detected Intel Wireless WiFi Link 4965AGN
> iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
> phy0: Selected rate control algorithm 'iwl-4965-rs'
> ACPI: PCI interrupt for device 0000:04:00.0 disabled
> EXT3 FS on sda3, internal journal
> Adding 987988k swap on /dev/sda2.  Priority:-1 extents:1 across:987988k
> r8169: eth0: link up
> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> PM: Writing back config space on device 0000:04:00.0 at offset 1 (was 100102, 
> writing 100106)
> firmware: requesting iwlwifi-4965-1.ucode
> Registered led device: iwl-phy0:radio
> Registered led device: iwl-phy0:assoc
> Registered led device: iwl-phy0:RX
> Registered led device: iwl-phy0:TX
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> iwl4965: Error sending REPLY_WEPKEY: enqueue_hcmd failed: -5
> mac80211-phy0: failed to remove key (0, ff:ff:ff:ff:ff:ff) from hardware (-5)
> iwl4965: Error sending REPLY_TX_PWR_TABLE_CMD: enqueue_hcmd failed: -5
> iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
> iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
> ...
> iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
> ACPI: PCI interrupt for device 0000:04:00.0 disabled
> 
> 
> [3.] Keywords (i.e., modules, networking, kernel):
> kernel, wifi, iwlwifi, asus, laptop
> [4.] Kernel version (from /proc/version):
> Linux version 2.6.23-gentoo-r2 (root@laptok) (gcc version 4.2.2 (Gentoo 4.2.2 
> p1.0)) #3 SMP Sun Jan 13 12:46:44 CET 2008
> [5.] Output of Oops.. message (if applicable) with symbolic information 
>      resolved (see Documentation/oops-tracing.txt)
> none
> [6.] A small shell script or example program which triggers the
>      problem (if possible)
> dmesg | grep -E '(KB)|(KiB)|(MB)'
> [7.] Environment
> [7.1.] Software (add the output of the ver_linux script here)
> [7.2.] Processor information (from /proc/cpuinfo):
> cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz
> stepping        : 10
> cpu MHz         : 1995.081
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 2
> core id         : 0
> cpu cores       : 2
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
> constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2 ssse3 cx16 
> xtpr lahf_lm
> bogomips        : 3992.41
> clflush size    : 64
> 
> X 2
> 
> [7.3.] Module information (from /proc/modules):
> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
> [7.5.] PCI information ('lspci -vvv' as root)
> [7.6.] SCSI information (from /proc/scsi/scsi)
> [7.7.] Other information that might be relevant to the problem
>        (please look in /proc and include all information that you
>        think to be relevant):
> [X.] Other notes, patches, fixes, workarounds:
> compressed files:
> dmesg-2.6.23
> dmesg-2.6.26
> .config-2.6.26
> .config-2.6.23
> at http://michal.kudla.googlepages.com/iwl-problem.tar.gz

