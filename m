Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbYCENar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbYCENar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYCENaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:30:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:56514 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYCENa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:30:29 -0500
Subject: Re: 2.6.25-rc3-mm1
From: Kay Sievers <kay.sievers@vrfy.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
In-Reply-To: <47CE9A6B.9080006@openvz.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	 <47CE9A6B.9080006@openvz.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 14:31:06 +0100
Message-Id: <1204723866.5212.3.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+25tE6yLNxsAStocpjVCGGfv7Esqjsj0NPIXx
 PnZ00FdJgyEJkkQZWwxGgLGiqH1XPi6BRIHxaowumyRZCM0a4A
 B0JbwsvmeMi5vrEnHYGDADwAtTOPJt+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-05 at 16:04 +0300, Pavel Emelyanov wrote:
> With CONFIG_SYSFS not set got this on boot:
> 
> kobject: '<NULL>' (f88774c8): is not initialized, yet kobject_put() is
> ------------[ cut here ]------------
> WARNING: at lib/kobject.c:652 kobject_put+0x29/0x3c()
> Modules linked in: sky2 e1000
> Pid: 1303, comm: modprobe Not tainted 2.6.25-rc3-mm1 #79
>  [<c041855b>] warn_on_slowpath+0x40/0x66
>  [<c041c687>] irq_exit+0x50/0x67
>  [<c040cc70>] smp_apic_timer_interrupt+0x6e/0x7a
>  [<c0403380>] apic_timer_interrupt+0x28/0x30
>  [<c0418e36>] vprintk+0x2b0/0x2df
>  [<c04118e8>] __update_rq_clock+0x1d/0x110
>  [<c0565e43>] schedule_timeout+0x13/0x86
> 
>  [<c05656c2>] wait_for_common+0xd1/0x123
>  [<c0418e79>] printk+0x14/0x18
>  [<c04b34bf>] kobject_put+0x29/0x3c
>  [<c0431e39>] free_module+0x2f/0x72
>  [<c04328dd>] sys_init_module+0xa61/0x15d2
> 
>  [<c04ba863>] pci_bus_read_config_byte+0x0/0x58
>  [<c0454f87>] vfs_read+0x6c/0x8b
>  [<c0455323>] sys_read+0x3c/0x63
>  [<c04028b2>] sysenter_past_esp+0x5f/0x85
> 
>  =======================
> ---[ end trace d50646e8e8e48682 ]---

Does this fix it?:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=120fc3d77acfd91f3521737a440d42839c475982

Thanks,
Kay

