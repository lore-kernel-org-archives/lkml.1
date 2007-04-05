Return-Path: <linux-kernel-owner+w=401wt.eu-S1767298AbXDEUcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767298AbXDEUcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767303AbXDEUcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:32:16 -0400
Received: from rwcrmhc15.comcast.net ([216.148.227.155]:34408 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767298AbXDEUcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:32:13 -0400
X-Greylist: delayed 96980 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2007 16:32:13 EDT
Message-ID: <46155CFF.70701@wolfmountaingroup.com>
Date: Thu, 05 Apr 2007 14:33:03 -0600
From: "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20050921 Red Hat/1.7.12-1.4.1
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Preemption Broken:  centrino_target busted under SMP on 2.6.20.4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


BUG: using smp_processor_id() in preemptible [00000001] code: 
kondemand/0/2473
caller is centrino_target+0xfb/0x600
 [<401e3646>] debug_smp_processor_id+0x9e/0xb0
 [<40112afb>] centrino_target+0xfb/0x600
 [<40112a00>] centrino_target+0x0/0x600
 [<40305bd9>] __cpufreq_driver_target+0x5c/0x6b
 [<f897a537>] do_dbs_timer+0x1bc/0x208 [cpufreq_ondemand]
 [<40134a46>] run_workqueue+0x85/0x125
 [<40374f7f>] _spin_lock_irqsave+0x18/0x66
 [<f897a37b>] do_dbs_timer+0x0/0x208 [cpufreq_ondemand]
 [<401353fb>] worker_thread+0xf9/0x124
 [<401213b9>] default_wake_function+0x0/0xc
 [<40135302>] worker_thread+0x0/0x124
 [<40137b37>] kthread+0xb0/0xd9
 [<40137a87>] kthread+0x0/0xd9
 [<40104b2f>] kernel_thread_helper+0x7/0x10
 =======================

Jeff
