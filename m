Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbZIWFxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbZIWFxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 01:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZIWFxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 01:53:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:51091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZIWFxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 01:53:21 -0400
Message-ID: <4AB9B7B7.30200@kernel.org>
Date: Wed, 23 Sep 2009 14:52:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tony Vroon <tony@linx.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.31-07068-g43c1266 Early boot exception
References: <1253560490.2934.42.camel@localhost>	 <4AB7D349.4000802@zytor.com> <1253566046.2773.10.camel@localhost>	 <4AB89417.7090005@kernel.org> <1253648186.2766.5.camel@localhost>
In-Reply-To: <1253648186.2766.5.camel@localhost>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 05:52:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Tony Vroon wrote:
> On Tue, 2009-09-22 at 18:08 +0900, Tejun Heo wrote:
>> Can you please try the patch below?  Also, please build the kernel
>> with debug info and ask gdb which line the crash corresponds to?
>> ie. l *pcpu_embed_first_chunk+0x1e2
> 
> Patch applied, no additional output visible:
> OAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x10de8201 base: 0xfed00000
> SMP: allowing 12 CPUs, 0 hotplug CPUs
> Allocating PCI resources starting at b00000000 (gap:b0000000:30000000)
> NR_CPUS: 12 nr_cpumask_bits:12 nr_cpu_ids:12 nr_node_ids:2
> PERCPU: Embedded 23 pages/cpu @ffff880028200000 s73688 r0 d20520 u26214
> PANIC: early exception 06 rip 10:ffffffff81598250 error 0 cr2 d0fff6

Can you please do l on the above rip - ffffffff81598250?

Thanks.

-- 
tejun
