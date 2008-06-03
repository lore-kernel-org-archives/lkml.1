Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbYFCHgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbYFCHgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 03:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbYFCHgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 03:36:17 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:50020 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbYFCHgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 03:36:16 -0400
X-BigFish: VPS-39(zz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K1VMG2-01-IUG-01
Date: Tue, 3 Jun 2008 09:35:50 +0200
From: Robert Richter <robert.richter@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: Add PCI extended config space access for AMD
	Barcelona
Message-ID: <20080603073550.GS23679@erda.amd.com>
References: <20080526180616.GB2752@erda.amd.com> <20080528165813.8D8E5814C@erda.amd.com> <86802c440806021331x4a483201k83c5db040a6cb70b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86802c440806021331x4a483201k83c5db040a6cb70b@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Jun 2008 07:35:51.0015 (UTC) FILETIME=[728DEF70:01C8C54C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.06.08 13:31:38, Yinghai Lu wrote:
> > +               if (!raw_pci_ext_ops && cpu_has_pci_ext_cfg) {
> > +                       printk(KERN_INFO "PCI: Using configuration type 1 "
> > +                              "for extended access\n");
> > +                       raw_pci_ext_ops = &pci_direct_conf1;
> 
> can you add extra pci_direct_ext_conf1 intead?
> 
> so don't need change reg size in pci_direct_conf1

The reg size check is already in raw_pci_*. Both functions would be
almost identical. See my previous mail.

> also if could avoid cpu_has_pci_ext_cfg, it would be great...

I intend to implement pci_probe & PCI_HAS_EXT_CFG in a follow on patch
instead.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

