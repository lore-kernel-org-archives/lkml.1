Return-Path: <linux-kernel-owner+w=401wt.eu-S934445AbXJSX3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445AbXJSX3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 19:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758208AbXJSX3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 19:29:01 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:12636 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbXJSX27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 19:28:59 -0400
Date: Fri, 19 Oct 2007 17:28:21 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Kernel configuration of a two dual core processor - Xeon 5130
In-reply-to: <1192713583.032734.179390@e9g2000prf.googlegroups.com>
To: jmsanchezdiaz <jmsanchezdiaz@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <47193D95.7070102@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <1192631170.706960.217710@q3g2000prf.googlegroups.com>
 <1192713583.032734.179390@e9g2000prf.googlegroups.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jmsanchezdiaz wrote:
> On 17 oct, 16:26, jmsanchezdiaz <jmsanchezd...@gmail.com> wrote:
>> Hello,
>>
>> I have a two 2.00 GHz Dual-Core processor Intel Xeon 5130 machine, Bus
>> Speed 1333 MHz, L2 Cache 4 MB, System Memory Size 40 GB, System Memory
>> Speed: 667 MHz.
>>
>> /proc/cpuinfo:
>> -------------------
>>
>> processor       : 0
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 15
>> model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
>> stepping        : 6
>> cpu MHz         : 1995.032
>> cache size      : 4096 KB
>> physical id     : 0
>> siblings        : 2
>> core id         : 0
>> cpu cores       : 2
>> fdiv_bug        : no
>> hlt_bug         : no
>> f00f_bug        : no
>> coma_bug        : no
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 10
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
>> nx lm constant_tsc pni monitor ds_cpl vmx tm2 cx16 xtpr lahf_lm
>> bogomips        : 3993.93
>>
>> [...]And so on for the 3 other cores
>>
>> /proc/pci:
>> --------------
>> PCI devices found:
>>   Bus  0, device   0, function  0:
>>     Class 0600: PCI device 8086:25c0 (rev 18).
>>   Bus  0, device   2, function  0:
>>     Class 0604: PCI device 8086:25e2 (rev 18).
>>       IRQ 16.
>>       Master Capable.  No bursts.  Min Gnt=3.
>>   Bus  0, device   3, function  0:
>>     Class 0604: PCI device 8086:25e3 (rev 18).
>>       IRQ 16.
>>       Master Capable.  No bursts.  Min Gnt=3.
>>   Bus  0, device   4, function  0:
>>     Class 0604: PCI device 8086:25f8 (rev 18).
>>       IRQ 16.
>>       Master Capable.  No bursts.  Min Gnt=3.
>>   Bus  0, device   5, function  0:
>>     Class 0604: PCI device 8086:25e5 (rev 18).
>>   Bus  0, device   6, function  0:
>>     Class 0604: PCI device 8086:25f9 (rev 18).
>>       IRQ 16.
>>       Master Capable.  No bursts.  Min Gnt=3.
>>   Bus  0, device   7, function  0:
>>     Class 0604: PCI device 8086:25e7 (rev 18).
>>   Bus  0, device  16, function  0:
>>     Class 0600: PCI device 8086:25f0 (rev 18).
>>   Bus  0, device  16, function  1:
>>     Class 0600: PCI device 8086:25f0 (rev 18).
>>   Bus  0, device  16, function  2:
>>     Class 0600: PCI device 8086:25f0 (rev 18).
>>   Bus  0, device  17, function  0:
>>     Class 0600: PCI device 8086:25f1 (rev 18).
>>   Bus  0, device  19, function  0:
>>     Class 0600: PCI device 8086:25f3 (rev 18).
>>   Bus  0, device  21, function  0:
>>     Class 0600: PCI device 8086:25f5 (rev 18).
>>   Bus  0, device  22, function  0:
>>     Class 0600: PCI device 8086:25f6 (rev 18).
>>   Bus  0, device  28, function  0:
>>     Class 0604: PCI device 8086:2690 (rev 9).
>>       IRQ 16.
>>       Master Capable.  No bursts.  Min Gnt=3.
>>   Bus  0, device  29, function  0:
>>     Class 0c03: PCI device 8086:2688 (rev 9).
>>       IRQ 18.
>>       I/O at 0xbce0 [0xbcff].
>>   Bus  0, device  29, function  1:
>>     Class 0c03: PCI device 8086:2689 (rev 9).
>>       IRQ 19.
>>       I/O at 0xbcc0 [0xbcdf].
>>   Bus  0, device  29, function  2:
>>     Class 0c03: PCI device 8086:268a (rev 9).
>>       IRQ 18.
>>       I/O at 0xbca0 [0xbcbf].
>>   Bus  0, device  29, function  7:
>>     Class 0c03: PCI device 8086:268c (rev 9).
>>       IRQ 18.
>>       Non-prefetchable 32 bit memory at 0xfc900000 [0xfc9003ff].
>>   Bus  0, device  30, function  0:
>>     Class 0604: PCI device 8086:244e (rev 217).
>>  Master Capable.  No bursts.  Min Gnt=11.
>>   Bus  0, device  31, function  0:
>>     Class 0601: PCI device 8086:2670 (rev 9).
>>   Bus  0, device  31, function  1:
>>     Class 0101: PCI device 8086:269e (rev 9).
>>       IRQ 16.
>>       I/O at 0xfc00 [0xfc0f].
>>   Bus  5, device   0, function  0:
>>     Class 0604: PCI device 8086:3500 (rev 1).
>>       IRQ 16.
>>       Master Capable.  No bursts.  Min Gnt=7.
>>   Bus  5, device   0, function  3:
>>     Class 0604: PCI device 8086:350c (rev 1).
>>       Master Capable.  No bursts.  Min Gnt=7.
>>   Bus  6, device   0, function  0:
>>     Class 0604: PCI device 8086:3510 (rev 1).
>>       IRQ 16.
>>       Master Capable.  No bursts.  Min Gnt=3.
>>   Bus  6, device   1, function  0:
>>     Class 0604: PCI device 8086:3514 (rev 1).
>>       IRQ 16.
>>       Master Capable.  No bursts.  Min Gnt=3.
>>   Bus  3, device   0, function  0:
>>     Class 0604: PCI device 1166:0103 (rev 195).
>>       Master Capable.  No bursts.  Min Gnt=6.
>>   Bus  7, device   0, function  0:
>>     Class 0604: PCI device 1166:0103 (rev 195).
>>       Master Capable.  No bursts.  Min Gnt=6.
>>   Bus  4, device   0, function  0:
>>     Class 0200: PCI device 14e4:164c (rev 18).
>>       IRQ 16.
>>       Master Capable.  Latency=32.  Min Gnt=64.
>>       Non-prefetchable 64 bit memory at 0xf8000000 [0xf9ffffff].
>>   Bus  8, device   0, function  0:
>>     Class 0200: PCI device 14e4:164c (rev 18).
>>       IRQ 16.
>>       Master Capable.  Latency=64.  Min Gnt=64.
>>       Non-prefetchable 64 bit memory at 0xf4000000 [0xf5ffffff].
>>   Bus  1, device   0, function  0:
>>     Class 0604: PCI device 8086:032c (rev 9).
>>       Master Capable.  No bursts.  Min Gnt=6.
>>   Bus  2, device   8, function  0:
>>     Class 0100: PCI device 1000:0054 (rev 1).
>>       IRQ 17.
>>       Master Capable.  Latency=72.  Min Gnt=64.Max Lat=10.
>>       I/O at 0xec00 [0xecff].
>>       Non-prefetchable 64 bit memory at 0xfc7fc000 [0xfc7fffff].
>>       Non-prefetchable 64 bit memory at 0xfc7e0000 [0xfc7effff].
>>   Bus 11, device   0, function  0:
>>     Class 0200: PCI device 8086:105e (rev 6).
>>       IRQ 16.
>>       Non-prefetchable 32 bit memory at 0xfc4e0000 [0xfc4fffff].
>>       Non-prefetchable 32 bit memory at 0xfc4c0000 [0xfc4dffff].
>>       I/O at 0xdce0 [0xdcff].
>>    Bus 11, device   0, function  1:
>>     Class 0200: PCI device 8086:105e (rev 6).
>>       IRQ 20.
>>       Non-prefetchable 32 bit memory at 0xfc4a0000 [0xfc4bffff].
>>       Non-prefetchable 32 bit memory at 0xfc480000 [0xfc49ffff].
>>       I/O at 0xdcc0 [0xdcdf].
>>   Bus 13, device   0, function  0:
>>     Class 0604: PCI device 8086:0329 (rev 9).
>>       Master Capable.  No bursts.  Min Gnt=6.
>>   Bus 13, device   0, function  2:
>>     Class 0604: PCI device 8086:032a (rev 9).
>>       Master Capable.  No bursts.  Min Gnt=6.
>>   Bus 17, device  13, function  0:
>>     Class 0300: PCI device 1002:515e (rev 2).
>>       IRQ 21.
>>       Master Capable.  Latency=32.  Min Gnt=8.
>>       Prefetchable 32 bit memory at 0xd8000000 [0xdfffffff].
>>       I/O at 0xcc00 [0xccff].
>>       Non-prefetchable 32 bit memory at 0xfc1f0000 [0xfc1fffff].
>>
>> I installed a kernel 2.6.20-2925.9.fc7xen #1 SMP Tue May 22 08:53:03
>> EDT 2007 i686 i686 i386 GNU/Linux with Fedora Core 7. I downloaded a
>> 2.6.22-9 kernel to update the kernel. I did a "make oldconfig". I
>> recompiled the kernel and when I start with the 2.6.22-9 kernel it
>> said to me:
>>
>> End_request: i/o error, dev fd0, sector0
>> Unable to access resume device (LABEL=SWAP-sda2)
>> mount: could not find filesystem 'dev/root'
>> setuproot: moving /dev failed
>> setuproot: moving /proc failed
>> setuproot: moving /sys failed
>> switchroot: mount failed
>> [...] Kernel panic
>>
>> Are there in the xconfig an special carachteristic to configure for
>> this machine?
>>
>> Are there some site where explains each option of the kernel
>> carachteristics for configuring mi machine ad hoc?
>> I dont know the meaning of many of them.
>>
>> Thank you very much.
>>
>> José Manuel.
> 
> When I only put in the grub the option rhgb, without quiet, these are
> the messages it shown:
> 
> Creating initial devices nodes
> 
> Setting up hotplug
> 
> atkbc.c: Spurious NAK on: isa0060/serio60 Some program might be trying
> access hardware directly
> 
> Creating block devices nodes
> 
> input: ps/2 Generic Mouse as /class/input/input1
> 
> Creating root device
> 
> End_request: i/o error, dev fd0, sector0
>  mounting root filesystem
> End_request: i/o error, dev fd0, sector0
> mount: could not find filesystem 'dev/root'
> Setting up other filesystems
> Setting up new root fs
> setuproot: moving /dev failed: No such file or directory
> no fstab.sys mounting internal defaults
> setuproot: moving /proc failed: No such file or directory
> setuproot: moving /sys failed: No such file or directory
> switching to new root and running init
> 
> umounting old /dev
> umounting old /proc
> umounting old /sys
> 
> switchroot: mount failed: No such file or directory
> 
> Booting has failed
> Kernel panic - not syncing: Attempting to kill init!
> 
> 
> May you help me with some clue? Thanks for all,

Quite likely you didn't enable whatever driver your system needs to 
access the hard drive..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

