Return-Path: <linux-kernel-owner+w=401wt.eu-S932573AbZJFQsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbZJFQsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756855AbZJFQsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:48:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:57317 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792AbZJFQsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:48:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,513,1249282800"; 
   d="scan'208";a="557039466"
Date: Tue, 6 Oct 2009 09:47:28 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: overwite pci bridge res regs to get big range
Message-ID: <20091006094728.289f3c25@jbarnes-g45>
In-Reply-To: <4AAD78C6.2010300@kernel.org>
References: <4AAD78C6.2010300@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Sep 2009 15:57:10 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> 
> found one system:
> [   71.120590] pci 0000:40:05.0: scanning behind bridge, config
> 4f4a40, pass 0 [   71.138283] PCI: Scanning bus 0000:4a
> [   71.140341] pci 0000:4a:00.0: found [15b3:6278] class 000c06
> header type 00 [   71.157173] pci 0000:4a:00.0: reg 10 64bit mmio:
> [0x000000-0x0fffff] [   71.161697] pci 0000:4a:00.0: reg 18 64bit
> mmio pref: [0x000000-0x7fffff] [   71.179403] pci 0000:4a:00.0: reg
> 20 64bit mmio pref: [0x000000-0xfffffff] [   71.185366] pci
> 0000:4a:00.0: calling quirk_resource_alignment+0x0/0x1dd
> [   71.200846] pci 0000:4a:00.0: disabling ASPM on pre-1.1 PCIe
> device.  You can enable it with 'pcie_aspm=force' [   71.219623] PCI:
> Fixups for bus 0000:4a [   71.222194] pci 0000:40:05.0: bridge 32bit
> mmio: [0xcf000000-0xcf0fffff] [   71.238662] pci 0000:40:05.0: bridge
> 64bit mmio pref: [0xcd800000-0xcdffffff] [   71.255793] PCI: Bus scan
> for 0000:4a returning with max=4a

Applied to my for-linus branch, thanks Yinghai.

-- 
Jesse Barnes, Intel Open Source Technology Center
