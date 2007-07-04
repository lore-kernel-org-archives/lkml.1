Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbXGDJdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbXGDJdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 05:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbXGDJdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 05:33:41 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1077 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432AbXGDJdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 05:33:40 -0400
Date: Wed, 4 Jul 2007 11:33:38 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.21.1] BUG: soft lockup detected on CPU#1
Message-ID: <20070704093338.GG4798@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Mon Jul  2 22:39:11 CEST 2007
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[228719.551711] BUG: soft lockup detected on CPU#1!
[228719.551797]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
[228719.551901]  [<c1004d7b>] show_trace+0x12/0x14
[228719.551997]  [<c1004e75>] dump_stack+0x16/0x18
[228719.552090]  [<c104ddc7>] softlockup_tick+0xa6/0xc2
[228719.552187]  [<c1026855>] run_local_timers+0x12/0x14
[228719.552288]  [<c1026669>] update_process_times+0x72/0xa1
[228719.552387]  [<c10386cb>] tick_sched_timer+0x53/0xb6
[228719.552488]  [<c1033dba>] hrtimer_interrupt+0x189/0x1e3
[228719.552588]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
[228719.552694]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
[228719.552790]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
[228719.552886]  [<c10020f2>] cpu_idle+0x6b/0x85
[228719.552982]  [<c130e218>] start_secondary+0xe8/0x30a
[228719.553086]  [<00000000>] 0x0
[228719.553207]  =======================


Folkert van Heusden

-- 
Feeling generous? -> http://www.vanheusden.com/wishlist.php
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
