Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbYJNAzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbYJNAzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 20:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbYJNAy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 20:54:58 -0400
Received: from smtp2.ono.com ([62.42.230.20]:6102 "EHLO resmaa04.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758297AbYJNAy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 20:54:57 -0400
Date: Tue, 14 Oct 2008 02:54:53 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.27-git3: no SD card reader
Message-ID: <20081014025453.617f2ef8@werewolf.home>
X-Mailer: Claws Mail 3.6.1cvs2 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

More problems with git3. The left SD card reader is not detected on the One.
With a working kernel (distro 2.6.27):

Oct 14 02:37:34 one kernel: sdhci: Secure Digital Host Controller Interface driver
Oct 14 02:37:34 one kernel: sdhci: Copyright(c) Pierre Ossman
Oct 14 02:37:34 one kernel: sdhci-pci 0000:01:00.0: SDHCI controller found [197b:2382] (rev 0)
Oct 14 02:37:34 one kernel: sdhci-pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 14 02:37:34 one kernel: sdhci-pci 0000:01:00.0: setting latency timer to 64
Oct 14 02:37:34 one kernel: mmc0: SDHCI controller on PCI [0000:01:00.0] using ADMA
Oct 14 02:37:34 one kernel: sdhci-pci 0000:01:00.2: SDHCI controller found [197b:2381] (rev 0)
Oct 14 02:37:34 one kernel: sdhci-pci 0000:01:00.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 14 02:37:34 one kernel: sdhci-pci 0000:01:00.2: Refusing to bind to secondary interface.
Oct 14 02:37:34 one kernel: sdhci-pci 0000:01:00.2: PCI INT A disabled
Oct 14 02:37:34 one kernel: sdhci-pci 0000:04:00.0: SDHCI controller found [197b:2382] (rev 0)
Oct 14 02:37:34 one kernel: sdhci-pci 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Oct 14 02:37:34 one kernel: sdhci-pci 0000:04:00.0: setting latency timer to 64
Oct 14 02:37:34 one kernel: mmc1: SDHCI controller on PCI [0000:04:00.0] using ADMA
Oct 14 02:37:34 one kernel: sdhci-pci 0000:04:00.2: SDHCI controller found [197b:2381] (rev 0)
Oct 14 02:37:34 one kernel: sdhci-pci 0000:04:00.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Oct 14 02:37:34 one kernel: sdhci-pci 0000:04:00.2: Refusing to bind to secondary interface.
Oct 14 02:37:34 one kernel: sdhci-pci 0000:04:00.2: PCI INT A disabled
Oct 14 02:37:34 one kernel: jmb38x_ms 0000:01:00.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 14 02:37:34 one kernel: jmb38x_ms 0000:01:00.3: setting latency timer to 64
Oct 14 02:37:34 one kernel: jmb38x_ms 0000:04:00.3: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Oct 14 02:37:34 one kernel: jmb38x_ms 0000:04:00.3: setting latency timer to 64
Oct 14 02:37:34 one kernel: mmc0: new SD card at address 0002
Oct 14 02:37:34 one kernel: mmc1: new SDHC card at address 0002
Oct 14 02:37:34 one kernel: mmcblk0: mmc0:0002 00000 1974272KiB
Oct 14 02:37:34 one kernel:  mmcblk0: unknown partition table
Oct 14 02:37:34 one kernel: mmcblk1: mmc1:0002       7917568KiB
Oct 14 02:37:34 one kernel:  mmcblk1: p1

With -git3:

Oct 14 02:44:27 one kernel: sdhci: Secure Digital Host Controller Interface driver
Oct 14 02:44:27 one kernel: sdhci: Copyright(c) Pierre Ossman
Oct 14 02:44:27 one kernel: jmb38x_ms 0000:01:00.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 14 02:44:27 one kernel: jmb38x_ms 0000:01:00.3: setting latency timer to 64
Oct 14 02:44:27 one kernel: jmb38x_ms 0000:04:00.3: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Oct 14 02:44:27 one kernel: jmb38x_ms 0000:04:00.3: setting latency timer to 64
Oct 14 02:44:27 one kernel: sdhci-pci 0000:01:00.0: SDHCI controller found [197b:2382] (rev 0)
Oct 14 02:44:27 one kernel: sdhci-pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 14 02:44:27 one kernel: sdhci-pci 0000:01:00.0: setting latency timer to 64
Oct 14 02:44:27 one kernel: mmc0: SDHCI controller on PCI [0000:01:00.0] using ADMA
Oct 14 02:44:27 one kernel: sdhci-pci 0000:01:00.2: SDHCI controller found [197b:2381] (rev 0)
Oct 14 02:44:27 one kernel: sdhci-pci 0000:01:00.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 14 02:44:27 one kernel: sdhci-pci 0000:01:00.2: Refusing to bind to secondary interface.
Oct 14 02:44:27 one kernel: sdhci-pci 0000:01:00.2: PCI INT A disabled
Oct 14 02:44:27 one kernel: sdhci-pci 0000:04:00.0: SDHCI controller found [197b:2382] (rev 0)
Oct 14 02:44:27 one kernel: sdhci-pci 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Oct 14 02:44:27 one kernel: sdhci-pci 0000:04:00.0: setting latency timer to 64
Oct 14 02:44:27 one kernel: mmc1: SDHCI controller on PCI [0000:04:00.0] using ADMA
Oct 14 02:44:27 one kernel: sdhci-pci 0000:04:00.2: SDHCI controller found [197b:2381] (rev 0)
Oct 14 02:44:27 one kernel: sdhci-pci 0000:04:00.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Oct 14 02:44:27 one kernel: sdhci-pci 0000:04:00.2: Refusing to bind to secondary interface.
Oct 14 02:44:27 one kernel: sdhci-pci 0000:04:00.2: PCI INT A disabled
Oct 14 02:44:27 one kernel: mmc0: error -84 whilst initialising SD card

Any ideas ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
