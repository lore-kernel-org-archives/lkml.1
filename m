Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbYFCH00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbYFCH00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 03:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYFCH0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 03:26:18 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:56028 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYFCH0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 03:26:17 -0400
X-BigFish: VPS-41(zz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K1VLZK-01-IGF-01
Date: Tue, 3 Jun 2008 09:25:50 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: Add PCI extended config space access for AMD
	Barcelona
Message-ID: <20080603072550.GR23679@erda.amd.com>
References: <20080526180616.GB2752@erda.amd.com> <20080528165813.8D8E5814C@erda.amd.com> <20080528120253.26fcdb9d@infradead.org> <20080602141928.GH23679@erda.amd.com> <20080602193527.722fbbce@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080602193527.722fbbce@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Jun 2008 07:25:51.0144 (UTC) FILETIME=[0D00E280:01C8C54B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.06.08 19:35:27, Arjan van de Ven wrote:
> > An alternative implementation would be here to use a check something
> > like pci_probe & PCI_HAS_EXT_CFG. If needed, I will send an updated
> > patch.
> 
> I kind of prefer this, since logically this is a PCI not a CPU property.
> Would you mind doing this ?
> (not that your current patch is wrong, it's just nicer to keep CPU
> stuff with the CPU and PCI stuff with PCI :)
> (This wouldn't need to stop inclusion of your current patch, it can
> just be an incremental cleanup)

Ok, I will send a follow on patch of this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

