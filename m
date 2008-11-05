Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYKEJNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYKEJNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbYKEJNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:13:19 -0500
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1438 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbYKEJNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:13:17 -0500
Date: Wed, 5 Nov 2008 10:13:14 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.18] BUG: warning at kernel/cpu.c:51/unlock_cpu_hotplug()
Message-ID: <20081105091314.GQ23232@vanheusden.com>
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
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Wed Nov  5 16:29:01 CET 2008
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While running 2.6.18 on an IBM x3650 with nothing but setiathome (there
are 2 quadcores and 10GB ram in this device) I get the following errors:

BUG: warning at kernel/cpu.c:51/unlock_cpu_hotplug()

Call Trace:
 [<ffffffff80293ed7>] unlock_cpu_hotplug+0x3f/0x6c
 [<ffffffff8822f2a7>] :cpufreq_ondemand:do_dbs_timer+0x119/0x171
 [<ffffffff80249150>] run_workqueue+0x94/0xe5
 [<ffffffff80245b22>] worker_thread+0x0/0x122
 [<ffffffff8028f8fc>] keventd_create_kthread+0x0/0x61
 [<ffffffff80245c12>] worker_thread+0xf0/0x122
 [<ffffffff8027c9b3>] default_wake_function+0x0/0xe
 [<ffffffff8028f8fc>] keventd_create_kthread+0x0/0x61
 [<ffffffff8028f8fc>] keventd_create_kthread+0x0/0x61
 [<ffffffff802305dc>] kthread+0xd4/0x107
 [<ffffffff80258aa0>] child_rip+0xa/0x12
 [<ffffffff8028f8fc>] keventd_create_kthread+0x0/0x61
 [<ffffffff80230508>] kthread+0x0/0x107
 [<ffffffff80258a96>] child_rip+0x0/0x12

errors: they come by regularly, like 25 times in the 56 minutes this
system has been up.


Folkert van Heusden

-- 
                     www.ishetweekend.nl
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
