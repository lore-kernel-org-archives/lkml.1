Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbXGMU7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbXGMU7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 16:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbXGMU7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 16:59:32 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3403 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbXGMU7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 16:59:31 -0400
Date: Fri, 13 Jul 2007 22:59:27 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Cc: clemens@ladisch.de
Subject: [2.6.21.1] BUG: soft lockup detected on CPU#1!
Message-ID: <20070713205927.GF29825@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Fri Jul 13 18:08:30 CEST 2007
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My system triggered a soft lockup bug:

[169034.197159] BUG: soft lockup detected on CPU#1!
[169034.197232]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
[169034.197326]  [<c1004d7b>] show_trace+0x12/0x14
[169034.197406]  [<c1004e75>] dump_stack+0x16/0x18
[169034.197488]  [<c104ddc7>] softlockup_tick+0xa6/0xc2
[169034.197572]  [<c1026855>] run_local_timers+0x12/0x14
[169034.197656]  [<c102662d>] update_process_times+0x36/0xa1
[169034.197740]  [<c10386cb>] tick_sched_timer+0x53/0xb6
[169034.197823]  [<c1033dba>] hrtimer_interrupt+0x189/0x1e3
[169034.197907]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
[169034.197996]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
[169034.198078]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
[169034.198162]  =======================


Folkert van Heusden

-- 
MultiTail ist eine flexible Applikation um Logfiles und Kommando
Eingaben zu überprüfen. Inkl. Filter, Farben, Zusammenführen,
Ansichten etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
