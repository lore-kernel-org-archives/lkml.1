Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbYCENig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbYCENig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbYCENi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:38:26 -0500
Received: from sacred.ru ([62.205.161.221]:50305 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbYCENiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:38:25 -0500
Message-ID: <47CEA247.1040506@openvz.org>
Date: Wed, 05 Mar 2008 16:38:15 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc3-mm1
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>	 <47CE9A6B.9080006@openvz.org> <1204723866.5212.3.camel@lov.site>
In-Reply-To: <1204723866.5212.3.camel@lov.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 05 Mar 2008 16:38:11 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Wed, 2008-03-05 at 16:04 +0300, Pavel Emelyanov wrote:
>> With CONFIG_SYSFS not set got this on boot:
>>
>> kobject: '<NULL>' (f88774c8): is not initialized, yet kobject_put() is
>> ------------[ cut here ]------------
>> WARNING: at lib/kobject.c:652 kobject_put+0x29/0x3c()
>> Modules linked in: sky2 e1000
>> Pid: 1303, comm: modprobe Not tainted 2.6.25-rc3-mm1 #79
>>  [<c041855b>] warn_on_slowpath+0x40/0x66
>>  [<c041c687>] irq_exit+0x50/0x67
>>  [<c040cc70>] smp_apic_timer_interrupt+0x6e/0x7a
>>  [<c0403380>] apic_timer_interrupt+0x28/0x30
>>  [<c0418e36>] vprintk+0x2b0/0x2df
>>  [<c04118e8>] __update_rq_clock+0x1d/0x110
>>  [<c0565e43>] schedule_timeout+0x13/0x86
>>
>>  [<c05656c2>] wait_for_common+0xd1/0x123
>>  [<c0418e79>] printk+0x14/0x18
>>  [<c04b34bf>] kobject_put+0x29/0x3c
>>  [<c0431e39>] free_module+0x2f/0x72
>>  [<c04328dd>] sys_init_module+0xa61/0x15d2
>>
>>  [<c04ba863>] pci_bus_read_config_byte+0x0/0x58
>>  [<c0454f87>] vfs_read+0x6c/0x8b
>>  [<c0455323>] sys_read+0x3c/0x63
>>  [<c04028b2>] sysenter_past_esp+0x5f/0x85
>>
>>  =======================
>> ---[ end trace d50646e8e8e48682 ]---
> 
> Does this fix it?:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=120fc3d77acfd91f3521737a440d42839c475982

This is already in 2.6.25-rc3-mm1, so the answer is "no it does not" :)

> Thanks,
> Kay
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

