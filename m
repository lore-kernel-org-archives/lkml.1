Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbZDSUYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbZDSUYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 16:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbZDSUYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 16:24:39 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:57816 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814AbZDSUYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 16:24:39 -0400
From: Yannick Roehlly <yannick.roehlly@free.fr>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
Date: Sun, 19 Apr 2009 22:24:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2; KDE/4.2.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <49E00E9F.8030605@kernel.org> <200904192135.36389.yannick.roehlly@free.fr> <86802c440904191259w4d9687f8u835b1a3d15e84e61@mail.gmail.com> (sfid-20090419_222050_328698_FFFFFFFFEA2BD084)
In-Reply-To: <86802c440904191259w4d9687f8u835b1a3d15e84e61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_4h46JAoj0X6ZKpF"
Message-Id: <200904192224.24429.yannick.roehlly@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_4h46JAoj0X6ZKpF
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le Sunday 19 April 2009 21:59:47 Yinghai Lu, vous avez =E9crit :
> On Sun, Apr 19, 2009 at 12:35 PM, Yannick Roehlly
> thanks. can you post cat /proc/iomem ?

Here it is.

Yannick



--Boundary-00=_4h46JAoj0X6ZKpF
Content-Type: text/plain;
  charset="UTF-8";
  name="iomem"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="iomem"

00000000-0000ffff : reserved
00010000-0009bbff : System RAM
0009bc00-0009ffff : reserved
000e3000-000fffff : reserved
00100000-bff9ffff : System RAM
  00200000-00470375 : Kernel code
  00470376-005aaadf : Kernel data
  00677000-0073b01b : Kernel bss
bffa0000-bffadfff : ACPI Tables
bffae000-bffeffff : ACPI Non-volatile Storage
bfff0000-bfffffff : reserved
c0000000-cfffffff : PCI Bus 0000:01
  c0000000-cfffffff : 0000:01:00.0
ddf00000-dfefffff : PCI Bus 0000:06
e0000000-efffffff : PCI MMCONFIG 0 [00-ff]
  e0000000-efffffff : pnp 00:0c
fdd00000-fddfffff : PCI Bus 0000:01
  fddc0000-fdddffff : 0000:01:00.0
  fddf0000-fddfffff : 0000:01:00.0
fde00000-fdefffff : PCI Bus 0000:02
  fdea0000-fdebffff : 0000:02:00.0
  fdec0000-fdefffff : 0000:02:00.0
    fdec0000-fdefffff : atl1
fdf00000-fdffffff : PCI Bus 0000:03
  fdffe000-fdffffff : 0000:03:00.0
    fdffe000-fdffffff : iwlagn
fe000000-fe0fffff : PCI Bus 0000:04
  fe0fe000-fe0fffff : 0000:04:00.0
    fe0fe000-fe0fffff : ahci
fe100000-fe8fffff : PCI Bus 0000:06
fe900000-fe9fffff : PCI Bus 0000:08
  fe9e0000-fe9effff : 0000:08:00.0
  fe9ffc00-fe9fffff : 0000:08:00.0
fea00000-feafffff : PCI Bus 0000:09
  feafe800-feafe8ff : 0000:09:01.4
  feafec00-feafecff : 0000:09:01.3
  feaff000-feaff0ff : 0000:09:01.2
  feaff400-feaff4ff : 0000:09:01.1
    feaff400-feaff4ff : mmc0
  feaff800-feafffff : 0000:09:01.0
    feaff800-feafffff : ohci1394
febf8000-febfbfff : 0000:00:1b.0
  febf8000-febfbfff : ICH HD audio
febff000-febff3ff : 0000:00:1d.7
  febff000-febff3ff : ehci_hcd
febff400-febff7ff : 0000:00:1a.7
  febff400-febff7ff : ehci_hcd
febff800-febfffff : 0000:00:1f.2
  febff800-febfffff : ahci
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : pnp 00:0a
fed00000-fed003ff : HPET 0
fed14000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:08
fed20000-fed3ffff : pnp 00:08
fed45000-fed89fff : pnp 00:08
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:0a
ffb00000-ffffffff : reserved
  ffb00000-ffbfffff : pnp 00:08
  fff00000-ffffffff : pnp 00:08
100000000-13fffffff : System RAM

--Boundary-00=_4h46JAoj0X6ZKpF--
