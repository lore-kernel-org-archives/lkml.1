Return-Path: <linux-kernel-owner+w=401wt.eu-S1750757AbXCCXbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750757AbXCCXbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 18:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbXCCXbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 18:31:55 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:18577 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbXCCXby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 18:31:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YlSGL9SVnWr5y5BihUrg5klx3Zl68QbtWsDUfrJzXnud4whWNmtTlgbhApEb/vSHguwpIE7xW8LlZdaVNI/Hv2I8kGAEUzuqQfTq6+knRlTjfkomMp5pD4zOcRLQvyOZ4aCwJmuTL8g9C9RWfeje9uwvtZzxHwFxUvzwXJ7ZjVM=
Message-ID: <6bffcb0e0703031531h3f0a86c6sda2522c0ca504765@mail.gmail.com>
Date: Sun, 4 Mar 2007 00:31:53 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: 2.6.21-rc2-git3 soft lockup detected on CPU#0 (crash dump kernel)
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hit this bug again
(http://www.ussg.iu.edu/hypermail/linux/kernel/0702.2/1643.html)

BUG: soft lockup detected on CPU#0!
 [<c1604556>] show_trace_log_lvl+0x1a/0x2f
 [<c1604c2c>] show_trace+0x12/0x14
 [<c1604cde>] dump_stack+0x16/0x18
 [<c16426e7>] softlockup_tick+0x97/0xa7
 [<c161de38>] run_local_timers+0x12/0x14
 [<c161e1ce>] update_process_times+0x3e/0x63
 [<c162c44b>] tick_sched_timer+0x5d/0xa1
 [<c1629715>] hrtimer_interrupt+0x11e/0x1b2
 [<c160684e>] timer_interrupt+0xe/0x15
 [<c164299e>] handle_IRQ_event+0x1a/0x46
 [<c1643cfe>] handle_level_irq+0x81/0xcb
 [<c1605dd8>] do_IRQ+0xb4/0xe0

This time it's a crash dump kernel without SMP.

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-git3-kdump/kdump-dmesg
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-git3-kdump/kdump-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
