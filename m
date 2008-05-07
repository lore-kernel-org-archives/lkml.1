Return-Path: <linux-kernel-owner+w=401wt.eu-S1765889AbYEGW5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765889AbYEGW5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYEGW51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:57:27 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:10019 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbYEGW5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:57:25 -0400
Message-ID: <482233CD.70502@googlemail.com>
Date: Thu, 08 May 2008 00:57:17 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: CONFIG_PRINTK_TIME broken on git HEAD ?
References: <48222C7C.2050807@googlemail.com> <20080507154155.2b472bb1.akpm@linux-foundation.org>
In-Reply-To: <20080507154155.2b472bb1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2008 22:50:25.0845 (UTC) FILETIME=[BD593E50:01C8B094]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 08 May 2008 00:26:04 +0200
> Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>> Hi all,
>>
>> I've updated today to 2.6.26-rc1-00166-gc0a1811 , running an 64bit kernel at the moment.
> 
> Which kernel were you runing previously?

2.6.25* , tested 2.6.25-git* , 2.6.26-rc1 , and 2.6.26-rc1-00065-g5717922.


>From my log 2.6.26-rc1-00065-g5717922 was fine.

...
 
May  6 00:13:14 thor kernel: [    0.000000] Allocating PCI resources starting at d0000000 (gap: cf600000:2f800000)
May  6 00:13:14 thor kernel: [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
May  6 00:13:14 thor kernel: [    0.000000] PERCPU: Allocating 41732 bytes of per cpu data
May  6 00:13:14 thor kernel: [    0.000000] Kernel command line: root=/dev/sdb1 ro debug vga=0x317
May  6 00:13:14 thor kernel: [    0.000000] Preemptible RCU implementation.
May  6 00:13:14 thor kernel: [    0.000000] Extended CMOS year: 2000
May  6 00:13:14 thor kernel: [    0.000000] TSC calibrated against PM_TIMER
May  6 00:13:14 thor kernel: [    0.000014] time.c: Detected 2499.952 MHz processor.
May  6 00:13:14 thor kernel: [    0.000032] console [tty0] enabled
May  6 00:13:14 thor kernel: [    0.000999] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
May  6 00:13:14 thor kernel: [    0.000999] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
May  6 00:13:14 thor kernel: [    0.000999] Checking aperture...

...

> 
>> dmesg shows here :
>>
>> ...
>>
>>
>> [    0.000000] Allocating PCI resources starting at d0000000 (gap: cf600000:2f800000)
>> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
>> [    0.000000] PERCPU: Allocating 42756 bytes of per cpu data
>> [    0.000000] NR_CPUS: 8, nr_cpu_ids: 4
>> [4294014.506571] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1010753
>> [4294014.506571] Kernel command line: root=/dev/sdb1 ro debug vga=0x317
>> [4294014.506571] Initializing CPU#0
>> [4294014.506571] Preemptible RCU implementation.
>> [4294014.506571] PID hash table entries: 4096 (order: 12, 32768 bytes) 
>>
>> ...                                                                                     
>>
>>
>> Is this a known issue ?
>>
> 
> Not to me.
> 

Gabriel
