Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbXGNLTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbXGNLTw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 07:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbXGNLTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 07:19:44 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:51116 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421AbXGNLTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 07:19:43 -0400
From: CIJOML <cijoml@volny.cz>
To: linux-kernel@vger.kernel.org
Subject: BUG: soft lockup detected on CPU#0!
Date: Sat, 14 Jul 2007 13:19:26 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707141319.26672.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

today I have expirienced soft lockup at 2.6.21 kernel. 2.6.22 is taking me 
same problem:

BUG: soft lockup detected on CPU#0!
 [<c013e904>] softlockup_tick+0x98/0xb5
 [<c01204f8>] update_process_times+0x33/0x55
 [<c012e48f>] tick_nohz_handler+0x54/0xb4
 [<c0110a59>] smp_apic_timer_interrupt+0x62/0x72
 [<c01046ac>] apic_timer_interrupt+0x28/0x30
 [<c01d7e93>] ioread32+0x21/0x22
 [<fc97802f>] snd_intel8x0_interrupt+0x17/0x1e3 [snd_intel8x0]
 [<f89730ad>] snd_intel8x0_interrupt+0x76/0x1d9 [snd_intel8x0m]
 [<c013eb7e>] handle_IRQ_event+0x1a/0x3f
 [<c013fdd6>] handle_level_irq+0x93/0xec
 [<c01061f6>] do_IRQ+0x79/0x93
 [<c0110a5e>] smp_apic_timer_interrupt+0x67/0x72
 [<c010467f>] common_interrupt+0x23/0x28
 [<fca48598>] ieee80211_send_probereq+0x93/0x277 [wlan]
 [<fca4dd6d>] scan_next+0x20b/0x47b [wlan]
 [<c011f7a7>] getnstimeofday+0x2b/0xac
 [<fca4db62>] scan_next+0x0/0x47b [wlan]
 [<c011fb92>] run_timer_softirq+0x102/0x176
 [<c012e208>] tick_program_event+0x2a/0x49
 [<c011cc1d>] __do_softirq+0x35/0x75
 [<c011cc7f>] do_softirq+0x22/0x26
 [<c011ce46>] irq_exit+0x29/0x62
 [<c0110a5e>] smp_apic_timer_interrupt+0x67/0x72
 [<c01046ac>] apic_timer_interrupt+0x28/0x30
 =======================

Michal
