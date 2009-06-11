Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbZFKEsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbZFKEsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 00:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZFKEr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 00:47:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:22922 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbZFKEr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 00:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=scXZyW93MP5F7WjVjAHwf8Hgg3LM9FK8MVhrRq7iAvHK63Hzln042Fxbhg5/st4N2S
         3E236p9rBngSIDnQ9FNd3CwuvxKoZFkRcShgf75NG/AXbR51sGQv0jB5AcmOK5P2zNsC
         8p2IIyy0JtfT0Slj290SQQUECiZ6UjavLSp4g=
MIME-Version: 1.0
In-Reply-To: <4A3086B2.2010900@gmail.com>
References: <9b1675090906101747u4ab8cc89t764ba80b4eb3dcb2@mail.gmail.com>
	 <86802c440906101754g496da536t48ade9b1b220449a@mail.gmail.com>
	 <9b1675090906101943x10dff40ak32341383a516ae7c@mail.gmail.com>
	 <4A3086B2.2010900@gmail.com>
Date: Wed, 10 Jun 2009 22:48:00 -0600
Message-ID: <9b1675090906102148m5634e652y34c101e28e4aab83@mail.gmail.com>
Subject: Re: Macbook 4G only see 3G
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 10:23 PM, Robert Hancock<hancockrwd@gmail.com> wrote:
> Trenton D. Adams wrote:
>> dmtdamac ~ # dmesg
>> Linux version 2.6.30-rc7-dirty (root@tdamac) (gcc version 4.3.2
>> (Gentoo 4.3.2-r3 p1.6, pie-10.1.5) ) #3 SMP Fri Jun 5 21:24:29 MDT
>> 2009
>> Command line: root=/dev/ram0 init=/linuxrc real_root=/dev/s/sys dolvm
>> hung_task_show_state=1
>> KERNEL supported cpus:
>>  Intel GenuineIntel
>>  AMD AuthenticAMD
>>  Centaur CentaurHauls
>> BIOS-provided physical RAM map:
>>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>>  BIOS-e820: 0000000000100000 - 00000000be08c000 (usable)
>>  BIOS-e820: 00000000be08c000 - 00000000be28d000 (ACPI NVS)
>>  BIOS-e820: 00000000be28d000 - 00000000beebe000 (ACPI data)
>>  BIOS-e820: 00000000beebe000 - 00000000beeef000 (ACPI NVS)
>>  BIOS-e820: 00000000beeef000 - 00000000bef00000 (ACPI data)
>>  BIOS-e820: 00000000bef00000 - 00000000c0000000 (reserved)
>>  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
>>  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
>>  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
>>  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
>>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>>  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
>
> The e820 map is the way that the BIOS tells us what memory is available.
>  Here it's only showing about 3040MB of usable memory, all below 4GB. The
> usual way that it should work with 4GB of RAM is that the portion of the
>  memory corresponding to the address space occupied for PCI devices, etc.
>  gets relocated above 4GB. However either the chipset in your machine
> doesn't support memory hole remapping, the BIOS doesn't bother to use it or
> it doesn't bother to tell Linux where it is..
>
> Do you know if Mac OS X is actually use all 4GB, or is it doing the "well,
> we can see there's actually 4GB installed but we won't mention that we can't
> use it all" trick, like some Windows does?
>

That is very well possible.  It did appear to have over 3G free, if I
recall correctly.  I'll try booting into Mac OS X again and see.

> Your dmesg shows your chiset is 945GM.
> ==
> intelfb 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> intelfb: 00:02.0: Intel(R) 945GM, aperture size 256MB, stolen memory 16124kB
> intelfb: Non-CRT device is enabled ( LVDS port ).  Disabling mode switching.
> intelfb: Video mode must be programmed at boot time.
> ==
> As far as I can found in English/Japanese forum, 945GM/PM? series can't handle
> 4G memory. (Then, 64bit Vista can't handle it, either)

That's my graphics card though, not my motherboard chipset.  The
chipset is ICH7.
tdamac ~ # lspci

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML
and 945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,
943/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller (rev 03)
00:07.0 Performance counters: Intel Corporation Device 27a3 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 2 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family)
SATA IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
01:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053
PCI-E Gigabit Ethernet Controller (rev 22)
02:00.0 Network controller: Atheros Communications Inc. AR5418
802.11abgn Wireless PCI Express Adapter (rev 01)
03:03.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 61)
