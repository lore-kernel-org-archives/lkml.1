Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647Ab0ANC1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0ANC1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599Ab0ANC1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:27:33 -0500
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:36461 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab0ANC1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:27:32 -0500
Message-ID: <4B4E80FC.8000108@cogweb.net>
Date: Wed, 13 Jan 2010 18:27:08 -0800
From: David Liontooth <lionteeth@cogweb.net>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.32.3 hpet swapper warning
References: <4B412287.5080902@cogweb.net>
In-Reply-To: <4B412287.5080902@cogweb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Possibly related --
http://bugzilla.kernel.org/show_bug.cgi?id=14141
http://bugzilla.kernel.org/show_bug.cgi?id=14265

WARNING: at arch/x86/kernel/hpet.c:390 hpet_next_event+0x70/0x80()
Hardware name: S3420GP
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.32.3 #2
Call Trace:
 [<ffffffff810287b0>] ? hpet_next_event+0x70/0x80
 [<ffffffff810287b0>] ? hpet_next_event+0x70/0x80
 [<ffffffff81044234>] ? warn_slowpath_common+0x74/0xd0
 [<ffffffff810287b0>] ? hpet_next_event+0x70/0x80
 [<ffffffff81066d56>] ? tick_dev_program_event+0x36/0xb0
 [<ffffffff81066699>] ? tick_broadcast_oneshot_control+0x119/0x120
 [<ffffffff81065e15>] ? tick_notify+0x255/0x430
 [<ffffffff8105ee97>] ? notifier_call_chain+0x37/0x70
 [<ffffffff81065711>] ? clockevents_notify+0x31/0x140
 [<ffffffff81236b69>] ? acpi_idle_enter_bm+0x153/0x274
 [<ffffffff81020080>] ? lapic_next_event+0x0/0x20
 [<ffffffff81329b0a>] ? cpuidle_idle_call+0xba/0x120
TCP cubic registered
 [<ffffffff8100b02a>] ? cpu_idle+0x5a/0xb0
---[ end trace 851596d83266edcb ]---

CE: hpet increasing min_delta_ns to 15000 nsec
CE: hpet increasing min_delta_ns to 22500 nsec


