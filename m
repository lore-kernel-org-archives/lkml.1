Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbYE2ORW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbYE2ORW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 10:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYE2ORK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 10:17:10 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:34966 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbYE2ORJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 10:17:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18494.47779.691031.764494@stoffel.org>
Date: Thu, 29 May 2008 10:16:03 -0400
From: "John Stoffel" <john@stoffel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: alejandro.riveira@gmail.com, linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: two different oopses with 2.6.26-rc4
In-Reply-To: <20080529012652.6b9027a3.akpm@linux-foundation.org>
References: <1211968234.9895.7.camel@Varda>
	<20080529012652.6b9027a3.akpm@linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andrew" == Andrew Morton <akpm@linux-foundation.org> writes:

Andrew> On Wed, 28 May 2008 11:50:34 +0200 Alejandro Riveira Fern__ndez  <alejandro.riveira@gmail.com> wrote:
>> I sent this to the list with other mail address and it didn't reach it
>> afaics. apologies if someone sees this twice
>> 
>> i cced wireless becouse of the first oops
>> 
>> First boot into 2.6.26-rc4 
>> 
>> Compiled and booting into 2.6.26-rc4
>> 
>> 1) With splash quiet on grub line it doesn't boot (or i didin't wait long
>> enough)
>> 2) without quiet and splash I get into VT X filas becouse i use the evil
>> nvidia driver that's expected. But ubuntu failsafe mode (xserver with vesa
>> in low res) doesn't show up either *regression*
>> 3) i get an oops with network manager
>> 4) if i try to run some sudo command it gets stuck (Crtl +C doesnt' help)
>> "ip route" gets stuck too. User programs i tried wrok fine (only ls and
>> htop). Network realted problem?
>> 
>> 5) printk times on dmesg go crazy
>> 
>> But the second time a boot into it i got a working system (i even compiled the
>> *famous* nvidia driver) with only a bluetooth related oops ...
>> 
>> Both dmesg follow. This is on a hardy 8.04 64 bits system. If more info is needed
>> just ask
>> 
>> No working first one
>> 
>> ...
>> 
>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>> [    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:3f380000)
>> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
>> [    0.000000] PERCPU: Allocating 33860 bytes of per cpu data
>> [    0.000000] NR_CPUS: 2, nr_cpu_ids: 2
>> [4294014.506571] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 774451
>> [4294014.506571] Kernel command line: BOOT_IMAGE=(hd0,2)/vmlinuz-2.6.26-rc4 root=UUID=ee465ea1-394d-4dd2-a5f9-a35567176c40 ro
>> [4294014.506571] Initializing CPU#0

Andrew> whee, time warp.

Andrew> Ingo, Thomas: what's the story here?  There've been zillions of reports
Andrew> and I thought we'd already fixed it?

I'm seeing the same type of timewarp on a 2.6.26-rc4 x86_64 running
with a pretty recent ASUS m2n-sli deluxe mobo with AMD x2 CPU.

  [    0.000000] PM: Registered nosave memory: 00000000fec00000 -
  0000000100000000
  [    0.000000] Allocating PCI resources starting at e0000000 (gap:
  dff00000:10100000)
  [    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
  [    0.000000] PERCPU: Allocating 33540 bytes of per cpu data
  [    0.000000] NR_CPUS: 8, nr_cpu_ids: 4
  [4294014.506571] Built 1 zonelists in Node order, mobility grouping
  on.  Total pages: 1030169
  [4294014.506571] Policy zone: Normal
  [4294014.506571] Kernel command line: root=/dev/sda2 ro
  earlyprintk=vga
  [4294014.506571] Initializing CPU#0
  [4294014.506571] Preemptible RCU implementation.
  [4294014.506571] PID hash table entries: 4096 (order: 12, 32768 byt


Haven't investigated in depth yet, but just chiming in with a report.

John
