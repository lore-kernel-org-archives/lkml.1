Return-Path: <linux-kernel-owner+w=401wt.eu-S1762752AbYGBHQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762752AbYGBHQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760417AbYGBHP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:15:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51985 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759727AbYGBHPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:15:55 -0400
Message-ID: <486B2AB0.1080506@cn.fujitsu.com>
Date: Wed, 02 Jul 2008 15:13:52 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] CFS vs cpu hotplug
References: <20080619161949.GA11062@osiris.ibm.com> <b647ffbd0806251512i3ab6efedv75a5bddd865ef618@mail.gmail.com> <b647ffbd0806281516i57392230idf06f99ff02d22cf@mail.gmail.com> <20080630090744.GB6598@osiris.boeblingen.de.ibm.com> <20080630091711.GA26637@elte.hu> <4869F770.6050103@cn.fujitsu.com> <20080701093124.GC31309@elte.hu>
In-Reply-To: <20080701093124.GC31309@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
>> The following oops still occurred whether this patch is applied or not.
> 
>>  [<ffffffff8059372c>] notifier_call_chain+0x33/0x5b
>>  [<ffffffff802476a9>] __raw_notifier_call_chain+0x9/0xb
>>  [<ffffffff802476ba>] raw_notifier_call_chain+0xf/0x11
>>  [<ffffffff805736d6>] _cpu_down+0x191/0x256
>>  [<ffffffff805737c1>] cpu_down+0x26/0x36
>>  [<ffffffff805749c1>] store_online+0x32/0x75
>>  [<ffffffff803d1982>] sysdev_store+0x24/0x26
>>  [<ffffffff802d2551>] sysfs_write_file+0xe0/0x11c
>>  [<ffffffff80290e6b>] vfs_write+0xae/0x137
>>  [<ffffffff802913d3>] sys_write+0x47/0x70
>>  [<ffffffff8020b1eb>] system_call_after_swapgs+0x7b/0x80
> 
> hm, there were multiple problems in this area and a lot of dormant bugs. 
> Do you have this recent upstream commit in your tree:
Hi, Ingo
	I tested it again with the most recent upstreams(including the
following patch) committed, the oops still occurred.

Thanks, Lai Jiangshan

> 
> | commit fcb43042ef55d2f46b0efa5d7746967cef38f056
> | Author: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> | Date:   Tue Jun 24 16:06:23 2008 +0800
> |
> |    x86: fix cpu hotplug crash
> |
> |    Vegard Nossum reported crashes during cpu hotplug tests:
> |
> |      http://marc.info/?l=linux-kernel&m=121413950227884&w=4
> 
> ?
> 
> 	Ingo
> 
> 
> 


