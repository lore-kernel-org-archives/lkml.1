Return-Path: <linux-kernel-owner+w=401wt.eu-S1761135AbYCERAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761135AbYCERAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbYCERAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:00:19 -0500
Received: from sacred.ru ([62.205.161.221]:43848 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833AbYCERAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:00:17 -0500
Message-ID: <47CED174.2080707@openvz.org>
Date: Wed, 05 Mar 2008 19:59:32 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.25-rc3-mm1
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <47CE9A6B.9080006@openvz.org> <20080305164045.GA31759@suse.de>
In-Reply-To: <20080305164045.GA31759@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 05 Mar 2008 19:59:25 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Mar 05, 2008 at 04:04:43PM +0300, Pavel Emelyanov wrote:
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
> 
> Hm, but with CONFIG_SYSFS set this does not show up?

Yes, with CONFIG_SYSFS set everything is OK.

> thanks,
> 
> greg k-h
> 

