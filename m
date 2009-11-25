Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZKYKhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZKYKhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758502AbZKYKhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:37:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48022 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758405AbZKYKhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:37:10 -0500
Date: Wed, 25 Nov 2009 11:37:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       peter.p.waskiewicz.jr@intel.com, peterz@infradead.org,
       arjan@linux.intel.com, yong.zhang0@gmail.com,
       linux-kernel@vger.kernel.org, arjan@linux.jf.intel.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter irqbalance hints
Message-ID: <20091125103713.GF29096@one.firstfloor.org>
References: <20091124.093956.247147202.davem@davemloft.net> <1259085412.2631.48.camel@ppwaskie-mobl2> <4B0C2547.8030408@gmail.com> <20091124.105442.06273019.davem@davemloft.net> <4B0C2CCA.6030006@gmail.com> <87iqczwtia.fsf@basil.nowhere.org> <4B0C4624.9080607@gmail.com> <4B0D0742.2050301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0D0742.2050301@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Works here
> 
> dmesg | grep -i node
> [    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 2 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 3 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 4 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 5 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 6 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 7 -> Node 0

You seem to only have 8 CPUs (one socket) Normally a dual socket nehalem
should have 16 with HyperThreading enabled.

For some reason the BIOS is not reporting the other CPU.

You could double check with acpidmp / iasl -d if that's
what the BIOS really reports, but normally it should work.

> [    0.000000] SRAT: Node 0 PXM 0 0-e0000000
> [    0.000000] SRAT: Node 0 PXM 0 100000000-220000000
> [    0.000000] SRAT: Node 1 PXM 1 220000000-420000000

-Andi

