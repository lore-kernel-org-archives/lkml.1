Return-Path: <linux-kernel-owner+w=401wt.eu-S1761227AbXHTQIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761227AbXHTQIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760172AbXHTQH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:07:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16612 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759821AbXHTQH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:07:58 -0400
Date: Mon, 20 Aug 2007 09:13:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: sk malik <srikrishanmalik@yahoo.co.in>
Cc: LKML1 <linux-kernel@vger.kernel.org>
Subject: Re: Boot hangs on IBM T60
Message-Id: <20070820091352.43f1f5bd.randy.dunlap@oracle.com>
In-Reply-To: <885593.28972.qm@web7610.mail.in.yahoo.com>
References: <885593.28972.qm@web7610.mail.in.yahoo.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007 16:10:11 +0100 (BST) sk malik wrote:

> Hi, all
> 
> It happens very rarely that the system hangs while
> booting.
> 
> The last message on console is :
> 
> Activating device mapper..
> 
> I dont' get any oops and the system works without any
> problem if it boots. :)
> 
> uname -a gives
>  2.6.18.8-0.5-default #1 SMP Fri Jun 22 12:17:53 UTC
> 2007 i686 i686 i386 GNU/Linux
> 
> Let me know if you need more information, with the
> steps to generate that info. :)
> 
> I am pasting a few lines which fall above and below
> the mapper activation as shown by dmesg for a
> successful boot.
> 
> Thanks 
> Sri 
> 
> Yenta: ISA IRQ mask 0x0cf0, PCI irq 169
> Socket status: 30000007
> pcmcia: parent PCI bridge I/O window: 0xa000 - 0xdfff
> cs: IO port probe 0xa000-0xdfff: clean.
> pcmcia: parent PCI bridge Memory window: 0xe4300000 -
> 0xe7ffffff
> pcmcia: parent PCI bridge Memory window: 0xe0000000 -
> 0xe3ffffff
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level,
> low) -> IRQ 82
> PCI: Setting latency timer of device 0000:03:00.0 to
> 64
> ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level,
> low) -> IRQ 82
> PCI: Setting latency timer of device 0000:00:1b.0 to
> 64
> ipw3945: Detected Intel PRO/Wireless 3945ABG Network
> Connection
> cs: IO port probe 0x100-0x3af: clean.
> cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
> cs: IO port probe 0x820-0x8ff: clean.
> cs: IO port probe 0xc00-0xcf7: clean.
> cs: IO port probe 0xa00-0xaff: clean.
> ipw3945: Radio Frequency Kill Switch is On:
> Kill switch must be turned off for wireless networking
> to work.
> Adding 1004020k swap on /dev/sda7.  Priority:-1
> extents:1 across:1004020k
> ##Here I get the "activating device mapper" on
> console## 
> device-mapper: ioctl: 4.7.0-ioctl (2006-06-24)
> initialised: dm-devel@redhat.com
> loop: loaded (max 8 devices)
> ReiserFS: sda6: found reiserfs format "3.6" with
> standard journal
> ReiserFS: sda6: using ordered data mode
> reiserfs: using flush barriers
> ReiserFS: sda6: journal params: device sda6, size
> 8192, journal first block 18, max trans len 1024, max
> batch 900, max commit age 30, max trans age 30
> ReiserFS: sda6: checking transaction log (sda6)
> ReiserFS: sda6: Using r5 hash to sort names
> NTFS driver 2.1.27 [Flags: R/W MODULE].
> NTFS volume version 3.1.
> ACPI: AC Adapter [AC] (off-line)
> ACPI: Battery Slot [BAT0] (battery present)
> ACPI: Power Button (FF) [PWRF]
> ACPI: Lid Switch [LID]
> ACPI: Sleep Button (CM) [SLPB]

Can you capture the boot log with another machine, either
via serial console or netconsole?
(See Documentation/serial-console.txt or
Documentation/networking/netconsole.txt).

If not, try booting with "initcall_debug" on the kernel boot line
and post that boot log so we can see the last initcall that was made.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
