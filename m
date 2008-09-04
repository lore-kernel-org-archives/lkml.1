Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYIDEqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYIDEqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 00:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYIDEqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 00:46:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbYIDEqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 00:46:44 -0400
Date: Wed, 3 Sep 2008 21:46:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for September 3
Message-Id: <20080903214634.ea17ff53.akpm@linux-foundation.org>
In-Reply-To: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008 19:16:19 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

The Vaio says:

calling  init_acpi_pm_clocksource+0x0/0x14a
initcall init_acpi_pm_clocksource+0x0/0x14a returned 0 after 32 msecs
calling  pcibios_assign_resources+0x0/0x70
pci 0000:06:05.0: BAR 9 too large: 0x00000000000000-0x00000003ffffff
pci 0000:06:05.0: CardBus bridge, secondary bus 0000:07
pci 0000:06:05.0:   IO window: 0x002400-0x0024ff
pci 0000:06:05.0:   IO window: 0x002800-0x0028ff
pci 0000:06:05.0:   MEM window: 0x54000000-0x57ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
pci 0000:00:1e.0:   MEM window: 0xb0100000-0xb01fffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:06:05.0: power state changed by ACPI to D0
found new irq_cfg for irq 21
 0 add_pin_to_irq: irq 21 --> apic 0 pin 21
found new irq_desc for irq 21
pci 0000:06:05.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21

Should I worry?

sony:/home/akpm> cat /proc/ioports 
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : ata_piix
0376-0376 : 0000:00:1f.1
  0376-0376 : ata_piix
03c0-03df : vesafb
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ata_piix
0680-068f : pnp 00:05
0800-080f : pnp 00:05
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
  1000-107f : pnp 00:05
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
    1008-100b : ACPI PM_TMR
    1010-1015 : ACPI CPU throttle
    1020-1020 : ACPI PM2_CNT_BLK
    1028-102f : ACPI GPE0_BLK
1080-109f : Sony Programable I/O Device
1180-11bf : 0000:00:1f.0
  1180-11bf : pnp 00:05
1800-1807 : 0000:00:02.0
180c-180f : 0000:00:1f.2
  180c-180f : ata_piix
1810-181f : 0000:00:1f.1
  1810-181f : ata_piix
1820-183f : 0000:00:1d.0
  1820-183f : uhci_hcd
1840-185f : 0000:00:1d.1
  1840-185f : uhci_hcd
1860-187f : 0000:00:1d.2
  1860-187f : uhci_hcd
1880-189f : 0000:00:1d.3
  1880-189f : uhci_hcd
18a8-18af : 0000:00:1f.2
  18a8-18af : ata_piix
18b0-18bf : 0000:00:1f.2
  18b0-18bf : ata_piix
18c0-18c3 : 0000:00:1f.2
  18c0-18c3 : ata_piix
18c8-18cf : 0000:00:1f.2
  18c8-18cf : ata_piix
18e0-18ff : 0000:00:1f.3
  18e0-18ff : i801_smbus
2000-2fff : PCI Bus 0000:06
  2000-203f : 0000:06:08.0
    2000-203f : e100
  2400-24ff : PCI CardBus 0000:07
  2800-28ff : PCI CardBus 0000:07
fe00-fe01 : pnp 00:05

sony:/home/akpm> cat /proc/iomem  
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000d8000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-3f68ffff : System RAM
  00100000-00330fd9 : Kernel code
  00330fda-0047fe7f : Kernel data
  004bc000-00ad7b13 : Kernel bss
3f690000-3f69cfff : ACPI Tables
3f69d000-3f6fffff : ACPI Non-volatile Storage
3f700000-3fffffff : reserved
50000000-5007ffff : 0000:00:02.1
50080000-50080fff : Intel Flush Page
50400000-507fffff : PCI CardBus 0000:07
54000000-57ffffff : PCI CardBus 0000:07
b0000000-b0003fff : 0000:00:1b.0
  b0000000-b0003fff : ICH HD audio
b0004000-b00043ff : 0000:00:1d.7
  b0004000-b00043ff : ehci_hcd
b0004400-b00047ff : 0000:00:1f.2
b0040000-b007ffff : 0000:00:02.0
b0080000-b00fffff : 0000:00:02.0
b0100000-b01fffff : PCI Bus 0000:06
  b0100000-b0103fff : 0000:06:05.2
  b0104000-b01047ff : 0000:06:05.2
    b0104000-b01047ff : ohci1394
  b0105000-b0105fff : 0000:06:05.3
  b0106000-b0106fff : 0000:06:08.0
    b0106000-b0106fff : e100
  b0107000-b0107fff : 0000:06:0b.0
    b0107000-b0107fff : ipw2200
  b0108000-b0108fff : 0000:06:05.0
    b0108000-b0108fff : yenta_socket
c0000000-cfffffff : 0000:00:02.0
  c0000000-c07affff : vesafb
d000c000-d000ffff : pnp 00:05
e0000000-f0005fff : reserved
  e0000000-efffffff : PCI MMCONFIG 0
f0008000-f000bfff : reserved
fec00000-fec00fff : IOAPIC 0
fed20000-fed8ffff : reserved
fee00000-fee00fff : Local APIC
ff000000-ffffffff : reserved

dmesg: http://userweb.kernel.org/~akpm/dmesg-sony.txt
config: http://userweb.kernel.org/~akpm/config-sony.txt

There are no immediately-obvious problems.  Apart from the lack of any
login prompt on the console (sshd works), but I suspect that was a
separate gift.
