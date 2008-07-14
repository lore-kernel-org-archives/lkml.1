Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbYGNJPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbYGNJPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 05:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbYGNJPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 05:15:44 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:5481 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbYGNJPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 05:15:43 -0400
X-BigFish: VPS-13(zz1432R98dR62a3L7efV1805M873fnzz10d3izzz32i6bh87il43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3ZODS-02-077-01
Date: Mon, 14 Jul 2008 11:15:07 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [osrc-patches] [PATCH] x86: Add PCI IDs for AMD Barcelona PCI
	devices
Message-ID: <20080714091506.GG7963@erda.amd.com>
References: <20080627140905.EBD1C83D4@erda.amd.com> <20080711124659.GC7963@erda.amd.com> <20080712045615.GA11092@elte.hu> <20080711220837.21f7d24a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080711220837.21f7d24a@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 14 Jul 2008 09:15:10.0669 (UTC) FILETIME=[1DB8B7D0:01C8E592]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.07.08 22:08:37, Arjan van de Ven wrote:
> On Sat, 12 Jul 2008 06:56:15 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Robert Richter <robert.richter@amd.com> wrote:
> > 
> > > Ingo, what about this patch. Could you apply it somewhere to the
> > > tip tree? I will then fix all hardcoded device entries in the code.
> > 
> > i suspect we could do it if the include/linux/pci_ids.h modification
> > is fine with Jesse - it appears the maintenance policy right now is
> > for everyone to add to include/linux/pci_ids.h on an as-needed basis:
> > 
> > $ git-log-line linus..linux-next include/linux/pci_ids.h
> > 
> > # 1126de5: Merge commit 'mmc/next'
> > # bd3b052: Merge commit 'galak/powerpc-next'
> > # edf0e24: powerpc/85xx: Add support for MPC8536DS
> > # 34f80b0: bnx2x: Add support for BCM57711 HW
> > # d3bca0e: sdhci: support JMicron secondary interface
> > # 4ae127d: Merge branch 'master' of
> > master.kernel.org:/pub/scm/linux/kernel/git/ # da65b53e4: Merge
> > branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/ #
> > da57e6983: tg3: Add 5785 ASIC revision
> > 
> > Which would normally go fine and not create conflicts because the 
> > modifications are distributed randomly over that file.
> > 
> > I'd suggest for you to send it together with the clean up patches, so 
> > that the context is clear.

Ok. Will do it that way.

> 
> actually lately for most cases it seems the plan isn't to add to
> pci_ids.h, but just do the PCI ID directly. It's not like a #define
> adds any kind of information.
> Vendor ID's otoh still happen (but obviously AMD is there since
> forever.)

Since the usage of these CPU device ids is spread over the whole
kernel it makes sence to define it at a single point in
pci_ids.h. This differs to device drivers that use only a single file
with all the code, and thus, global defines are not necessary.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

