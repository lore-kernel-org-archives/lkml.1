Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbYBAGZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbYBAGZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 01:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932483AbYBAGZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 01:25:28 -0500
Received: from hs-out-0708.google.com ([64.233.178.241]:59161 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755189AbYBAGZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 01:25:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YI4354FV2UPjZaLFcKb44KNIsZyoE8YbougHbbOqCqN3nvHzhrPwLtbxKr5xFLCbhZlkYwWcNJkUDzzPk6owl+BeTc6BeYhS8AGejVSZquVoQ4cFuoskZreuqpgBtPeCZxw9SzER5MkJvrg/R+woeyzvRXufsviOdIHA+eU2Ops=
Message-ID: <a8e1da0801312225ga908cc1o2d2d738c356214de@mail.gmail.com>
Date: Fri, 1 Feb 2008 14:25:12 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: rtc : lockdep warning
Cc: a.zummo@towertech.it
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2033 trace_hardirqs_on+0xe3/0x130()
Modules linked in: btusb intel_agp bluetooth snd_hda_intel evdev
agpgart thermal sg processor rtc_cmos button serio_raw i2c_i801
snd_pcm rtc_core pcspkr 3c59x rtc_lib snd_timer snd soundcore
snd_page_alloc
Pid: 2307, comm: hwclock Not tainted 2.6.24 #25
 [<c012b100>] ? zap_locks+0x40/0x70
 [<c012a894>] warn_on_slowpath+0x54/0x80
 [<c014d3b9>] ? mark_lock_irq+0x79/0x3b0
 [<c014cb72>] ? validate_chain+0x1d2/0x320
 [<c014dcc3>] ? mark_lock+0x93/0x1d0
 [<c010aaa5>] ? native_sched_clock+0x85/0xe0
 [<c014b42d>] ? put_lock_stats+0xd/0x30
 [<c014b4b0>] ? lock_release_holdtime+0x60/0x80
 [<c011a58f>] ? hpet_rtc_interrupt+0xcf/0x230
 [<c014ed87>] ? __lock_release+0x47/0x70
 [<c011a58f>] ? hpet_rtc_interrupt+0xcf/0x230
 [<c0424962>] ? _spin_unlock_irq+0x22/0x50
 [<c014d873>] trace_hardirqs_on+0xe3/0x130
 [<c0424962>] _spin_unlock_irq+0x22/0x50
 [<c011a58f>] hpet_rtc_interrupt+0xcf/0x230
 [<c015dfdf>] ? handle_edge_irq+0xaf/0x150
 [<c015cc38>] handle_IRQ_event+0x28/0x60
 [<c015dfe8>] handle_edge_irq+0xb8/0x150
 [<c0107afc>] do_IRQ+0x3c/0x80
 [<c014d849>] ? trace_hardirqs_on+0xb9/0x130
 [<c0105b2a>] common_interrupt+0x2e/0x34
 =======================
---[ end trace fb50847cfa3f5ac9 ]---
