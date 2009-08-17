Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbZHQWRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbZHQWRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZHQWRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:17:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:60403 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbZHQWRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:17:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,398,1246863600"; 
   d="scan'208";a="176757049"
Subject: Re: [regression, bisected] fails to boot on Dell Optiplex 760 with
 VT-d enabled
From: David Woodhouse <david.woodhouse@intel.com>
To: Faidon Liambotis <paravoid@debian.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Han, Weidong" <weidong.han@intel.com>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       "Yu, Fenghua" <fenghua.yu@intel.com>
In-Reply-To: <4A89CB52.4030008@debian.org>
References: <4A89CB52.4030008@debian.org>
Content-Type: text/plain
Organization: Intel Corporation. Pipers Way, Swindon, Wiltshire, SN3 1RJ,
 UK.
Date: Mon, 17 Aug 2009 23:17:03 +0100
Message-Id: <1250547423.7405.362.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 14:27 -0700, Faidon Liambotis wrote:
> I am experiencin a bug on an Dell Optiplex 760 with a configuration that
> has an Intel Core2 Q9550 CPU and with an up-to-date BIOS, version A03.
> 
> When "VT for Direct I/O" is enabled in the BIOS, v2.6.30 boots and works
> perfectly, while v2.6.31-rc1..rc6 fail (both of them x86-64).
> 
> More specifically, I get an endless loop of printing the following
> messages in
> the screen:
>         DMAR: [DMA Read] Request device [ff:1f.7] fault addr
>               fffffffffffff000
>         DMAR: [fault reason 255] Unknown
> and the boot process doesn't move on from there.

Is it fixed by http://git.infradead.org/iommu-2.6.git/commit/0815565a ?

I strongly suspect you weren't actually using the IOMMU in your
'working' 2.6.30 kernel? Can you show a full log of that one booting?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

