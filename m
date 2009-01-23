Return-Path: <linux-kernel-owner+w=401wt.eu-S1759308AbZAWHs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308AbZAWHs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 02:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZAWHsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 02:48:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:54391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbZAWHsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 02:48:36 -0500
Message-ID: <49797634.7040500@kernel.org>
Date: Thu, 22 Jan 2009 23:48:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: kernel panic when using disable_mtrr_trim [was: Re: memory
 	beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y]]
References: <49763718.7010501@kernel.org> <86802c440901201249v3c877a88ie8e5f3bbf6abb871@mail.gmail.com> <49794422.2080109@kernel.org>
In-Reply-To: <49794422.2080109@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Yinghai Lu wrote:
>> On Tue, Jan 20, 2009 at 12:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> with the config
>>>
>>> current tip said:
>>>
>>>  RELOCS  arch/x86/boot/compressed/vmlinux.relocs
>>> WARNING: Absolute relocations present
>>> Offset     Info     Type     Sym.Value Sym.Name
>>> c14d2186 00920e01   R_386_32 c1514000  __per_cpu_load
>>>
>> and will casue system reboot after
>>
>> [    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
>> [    0.000000] PERCPU: Allocating 36864 bytes of per cpu dat
> 
> Can you please try the current core/percpu branch?  I tried your
> config but the problem doesn't happen here.

current tip:
still got

WARNING: Absolute relocations present
Offset     Info     Type     Sym.Value Sym.Name
c14d21ef 00921101   R_386_32 c1514000  __per_cpu_load

reboot after

[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 36864 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2079274
[    0.000000] Kernel command line: console=uart8250,io,0x3f8,115200n8 initrd=kernel.org/mydisk11_x86.gz rw root=/dev/ram0 loglevel=10,apic:13,acpi:10,dev:10,pci:10 initcall_debug apic=verbose pci=routeirq ip=dhcp load_ramdisk=1 ramdisk_size=131072 BOOT_IMAGE=kernel.org/bzImage_2.6.29_x86.1 
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:320
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2700.114 MHz processor.


YH
