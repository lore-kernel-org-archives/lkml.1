Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbXIXMfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbXIXMfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbXIXMfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:35:38 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3396 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbXIXMfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:35:37 -0400
Date: Mon, 24 Sep 2007 13:35:31 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: 2.6.23-rc7-mm1 -- powerpc rtas panic
Message-ID: <20070924123531.GC30855@shadowen.org>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing the following from an older power LPAR, pretty sure we had
this in the previous -mm also:

Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc000000000047ac8
cpu 0x0: Vector: 300 (Data Access) at [c00000000058f750]
    pc: c000000000047ac8: .pSeries_log_error+0x364/0x420
    lr: c000000000047a4c: .pSeries_log_error+0x2e8/0x420
    sp: c00000000058f9d0
   msr: 8000000000001032
   dar: 0
 dsisr: 42000000
  current = 0xc0000000004a9b30
  paca    = 0xc0000000004aa700
    pid   = 0, comm = swapper
enter ? for help
[c00000000058faf0] c000000000021164 .rtas_call+0x200/0x250
[c00000000058fba0] c000000000049cd0 .early_enable_eeh+0x168/0x360
[c00000000058fc70] c00000000002f674 .traverse_pci_devices+0x8c/0x138
[c00000000058fd10] c000000000460ce8 .eeh_init+0x1a8/0x200
[c00000000058fdb0] c00000000045fb70 .pSeries_setup_arch+0x128/0x234
[c00000000058fe40] c00000000044f830 .setup_arch+0x214/0x24c
[c00000000058fee0] c000000000446a38 .start_kernel+0xd4/0x3e4
[c00000000058ff90] c000000000373194 .start_here_common+0x54/0x58

This machine is a:

processor       : 0
cpu             : POWER4+ (gq)
clock           : 1703.965296MHz
revision        : 19.0

[...]

timebase        : 212995662
machine         : CHRP IBM,7040-681

-apw
