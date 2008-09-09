Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbYIIQVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbYIIQVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYIIQVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:21:41 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:20269 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYIIQVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:21:40 -0400
X-BigFish: VPS-20(z1857rz1432R98dR1805M936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K6XS3G-03-QPR-01
Date: Tue, 9 Sep 2008 18:21:16 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: "Luck, Tony" <tony.luck@intel.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] add is_buffer_dma_capable helper function
Message-ID: <20080909162116.GB13536@amd.com>
References: <1220976409-8417-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220976409-8417-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <57C9024A16AD2D4C97DC78E552063EA30A14789F@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA30A14789F@orsmsx505.amr.corp.intel.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 09 Sep 2008 16:21:16.0213 (UTC) FILETIME=[1584E650:01C91298]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 09:17:05AM -0700, Luck, Tony wrote:
> +static inline int is_buffer_dma_capable(u64 mask, dma_addr_t addr, size_t size)
> +{
> +       return addr + size <= mask;
> +}
> 
> Do we care about wrap-around (e.g. addr=0xffffffffffffffff size=2)?

I don't think so. The current code does not care about it and if it
happens its a bug in the iommu implementation.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

