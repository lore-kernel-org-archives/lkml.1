Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbZGGIyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbZGGIyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZGGIyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:54:15 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:19292
	"EHLO WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751362AbZGGIyO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:54:14 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz1432R98dN1805M4cd6kzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KMEM29-01-QIS-01
Date: Tue, 7 Jul 2009 10:54:08 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Dave Airlie <airlied@gmail.com>
CC: Dave Airlie <airlied@linux.ie>, David Woodhouse <dwmw2@infradead.org>,
       Joerg Roedel <joro@8bytes.org>, Zhenyu Wang <zhenyu.z.wang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "mingo@redhat.com" <mingo@redhat.com>,
       David Miller <davem@davemloft.net>, "eric@anholt.net" <eric@anholt.net>
Subject: Re: IOMMU and graphics cards
Message-ID: <20090707085408.GO5380@amd.com>
References: <20090507164742V.fujita.tomonori@lab.ntt.co.jp>
 <20090507100114.GF4059@amd.com>
 <1241691721.3531.73.camel@macbook.infradead.org>
 <20090507.113632.210373283.davem@davemloft.net>
 <20090508093526.GB13708@8bytes.org>
 <1246883177.2615.33.camel@macbook.infradead.org>
 <20090706131156.GL5380@amd.com>
 <1246889932.2615.81.camel@macbook.infradead.org>
 <alpine.DEB.2.00.0907062232350.5769@skynet.skynet.ie>
 <0DDD3FAD-969A-421B-A36A-77AB645E8BCA@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <0DDD3FAD-969A-421B-A36A-77AB645E8BCA@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 Jul 2009 08:54:08.0728 (UTC) FILETIME=[7D6E4D80:01C9FEE0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 08:00:01AM +1000, Dave Airlie wrote:
> 
> Could you also enumerate any limitations of the IOMMUs on the amount
> of memory they can remap per device if any.

The AMD IOMMU driver in 2.6.31-rcX can map up to 4GB per domain. If the
gfx card has a domain of its own it can use all of the 4GB.
I am not 100% sure about VT-d, but as far as I understood the allocator
it doesn't have that 4GB limitation per domain.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

