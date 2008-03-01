Return-Path: <linux-kernel-owner+w=401wt.eu-S1761894AbYCAVDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761894AbYCAVDU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 16:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758455AbYCAVDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 16:03:13 -0500
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:44027
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758354AbYCAVDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 16:03:12 -0500
Date: Sat, 1 Mar 2008 13:03:11 -0800
From: Phil Oester <kernel@linuxace.com>
To: Clem Taylor <clem.taylor@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: e1000 driver not loading in 2.6.24.3 on x86_64 (worked in 2.6.24-rc7)
Message-ID: <20080301210311.GA10273@linuxace.com>
References: <ecb4efd10803011242w3874d27eyb1afaea06766bdbf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecb4efd10803011242w3874d27eyb1afaea06766bdbf@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 03:42:58PM -0500, Clem Taylor wrote:
> I'm trying to move from 2.6.24-rc7 to 2.6.24.3 on a x86_64 desktop
> machine. With 2.6.24.3, the e1000 driver (compiled in, not a module)
> does not claim the device. In 2.6.24-rc7 it works just fine.
> 
> The ethernet device shows up in lspci in both kernels, but the driver
> doesn't seem to probe the card in 2.6.24.3
> 
> 2.6.24-rc7:
> loop: module loaded
> Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
> Copyright (c) 1999-2006 Intel Corporation.
> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> PCI: Setting latency timer of device 0000:04:00.0 to 64
> e1000: 0000:04:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:16:76:c9:33>
> e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection

Note the difference between the above line start (e1000)
and this one:

> e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
> e1000e: Copyright (c) 1999-2007 Intel Corporation.

> 2.6.24.3:
> loop: module loaded

And note the absence of e1000 here:

> e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
> e1000e: Copyright (c) 1999-2007 Intel Corporation.
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2

In other words, you need the e1000 driver but don't have it.

Phil
