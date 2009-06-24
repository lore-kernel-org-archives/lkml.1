Return-Path: <linux-kernel-owner+w=401wt.eu-S1761658AbZFXT3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbZFXT3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZFXT3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:29:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbZFXT3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:29:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Justin Mattock <justinmattock@gmail.com>
Subject: Re: pci 0000:01:00.0: BAR 6: no parent found for of device [0xfffe0000-0xffffffff]
Date: Wed, 24 Jun 2009 21:30:07 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <dd18b0c30906241027u152274b1kd4c854ada4de33dd@mail.gmail.com>
In-Reply-To: <dd18b0c30906241027u152274b1kd4c854ada4de33dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906242130.07583.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding CC to linux-pci)

On Wednesday 24 June 2009, Justin Mattock wrote:
> (just pulled the latest git)
> And am seeing this:

Where pci 0000:01:00.0 and 0000:02:00.0 are what?

> [    0.696001] pci 0000:01:00.0: BAR 6: no parent found for of device
> [0xfffe0000-0xffffffff]
> [    0.696010] pci 0000:02:00.0: BAR 6: no parent found for of device
> [0xfffe0000-0xffffffff]
> [    0.696069] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
> [    0.696074] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
> [    0.696081] pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
> [    0.696087] pci 0000:00:01.0:   PREFETCH window:
> 0x00000040000000-0x00000047ffffff
> [    0.696096] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
> [    0.696102] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
> [    0.696111] pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
> [    0.696118] pci 0000:00:1c.0:   PREFETCH window: 0x50500000-0x505fffff
> [    0.696126] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
> [    0.696130] pci 0000:00:1c.1:   IO window: disabled
> [    0.696138] pci 0000:00:1c.1:   MEM window: 0x50100000-0x501fffff
> [    0.696145] pci 0000:00:1c.1:   PREFETCH window: disabled
> [    0.696152] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
> [    0.696158] pci 0000:00:1c.2:   IO window: 0x1000-0x1fff
> [    0.696167] pci 0000:00:1c.2:   MEM window: 0x4c100000-0x500fffff
> [    0.696174] pci 0000:00:1c.2:   PREFETCH window:
> 0x00000048000000-0x0000004bffffff
> [    0.696186] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
> [    0.696190] pci 0000:00:1e.0:   IO window: disabled
> [    0.696198] pci 0000:00:1e.0:   MEM window: 0x4c000000-0x4c0fffff
> [    0.696205] pci 0000:00:1e.0:   PREFETCH window: disabled
> [    0.696219] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.696225] pci 0000:00:01.0: setting latency timer to 64
> [    0.696235] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    0.696243] pci 0000:00:1c.0: setting latency timer to 64
> [    0.696254] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
> [    0.696261] pci 0000:00:1c.1: setting latency timer to 64
> [    0.696273] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    0.696280] pci 0000:00:1c.2: setting latency timer to 64
> [    0.696437] pci 0000:00:1e.0: power state changed by ACPI to D0
> [    0.696446] pci 0000:00:1e.0: setting latency timer to 64
> 
> 
> Is this good or bad?
> (BAR 6: no parent found for of device)

There may be devices without parents, although the message itself seems to be
broken.

Please send the output of lspci.

Best,
Rafael
