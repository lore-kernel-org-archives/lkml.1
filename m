Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYKFPu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYKFPu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYKFPuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:50:46 -0500
Received: from waste.org ([66.93.16.53]:35414 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbYKFPuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:50:44 -0500
Subject: iwlagn: wrong command queue 31, command id 0x0
From: Matt Mackall <mpm@selenic.com>
To: yi.zhu@intel.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 05 Nov 2008 22:16:19 -0600
Message-Id: <1225944979.3792.3.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of 75fa67706cce5272bcfc51ed646f2da21f3bdb6e, I'm seeing this:

[ 5470.869820] WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1204
iwl_rx_handle+0x11a/0x21b [iwlagn]()
[ 5470.869824] wrong command queue 31, command id 0x0
[ 5470.869827] Modules linked in: nls_utf8 hfsplus usb_storage uvcvideo
compat_ioctl32 videodev v4l1_compat iwlagn snd_hda_intel sdhci_pci
ehci_hcd uhci_hcd
[ 5470.869850] Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc3 #39
[ 5470.869854] Call Trace:
[ 5470.869858]  <IRQ>  [<ffffffff8024fc7e>] warn_slowpath+0xb4/0xda
[ 5470.869873]  [<ffffffff803559cd>] __next_cpu+0x19/0x26
[ 5470.869885]  [<ffffffffa009b032>] iwl_rx_handle+0x11a/0x21b [iwlagn]
[ 5470.869896]  [<ffffffffa009b335>] iwl4965_irq_tasklet+0x202/0x2b4
[iwlagn]
[ 5470.869906]  [<ffffffffa0097592>] iwl4965_isr+0x21/0x101 [iwlagn]
[ 5470.869912]  [<ffffffff80254459>] tasklet_action+0x89/0xf1
[ 5470.869918]  [<ffffffff80254c6b>] __do_softirq+0x8e/0x163
[ 5470.869925]  [<ffffffff8022674c>] call_softirq+0x1c/0x28
[ 5470.869930]  [<ffffffff80227db5>] do_softirq+0x45/0xa5
[ 5470.869935]  [<ffffffff802547a5>] irq_exit+0x4e/0x94
[ 5470.869946]  [<ffffffff8022802d>] do_IRQ+0xc2/0xe1
[ 5470.869950]  [<ffffffff80225338>] ret_from_intr+0x0/0x2e
[ 5470.869953]  <EOI>  [<ffffffff80265663>] ktime_get_ts+0x21/0x4a
[ 5470.869963]  [<ffffffff80391123>] acpi_idle_enter_bm+0x2ca/0x35c
[ 5470.869968]  [<ffffffff8039112b>] acpi_idle_enter_bm+0x2d2/0x35c
[ 5470.869973]  [<ffffffff80391123>] acpi_idle_enter_bm+0x2ca/0x35c
[ 5470.869979]  [<ffffffff80435f0e>] cpuidle_idle_call+0x90/0xce
[ 5470.869985]  [<ffffffff80223ec0>] cpu_idle+0x56/0x9a
[ 5470.869988] ---[ end trace cacb4f9954dd9364 ]---

Device is a 4965:

14:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or
AGN [Kedron] Network Connection (rev 61)

-- 
Mathematics is the supreme nostalgia of our time.

