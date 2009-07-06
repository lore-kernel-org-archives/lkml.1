Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbZGFNMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbZGFNMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZGFNMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:12:16 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:35031 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbZGFNMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:12:15 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz1432R98dN936eM1805M1878kzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KMD3BV-04-73Z-01
Date: Mon, 6 Jul 2009 15:11:56 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Joerg Roedel <joro@8bytes.org>, Zhenyu Wang <zhenyu.z.wang@intel.com>,
       airlied@linux.ie, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, iommu@lists.linux-foundation.org,
       mingo@redhat.com, David Miller <davem@davemloft.net>
Subject: Re: IOMMU and graphics cards
Message-ID: <20090706131156.GL5380@amd.com>
References: <20090507164742V.fujita.tomonori@lab.ntt.co.jp>
 <20090507100114.GF4059@amd.com>
 <1241691721.3531.73.camel@macbook.infradead.org>
 <20090507.113632.210373283.davem@davemloft.net>
 <20090508093526.GB13708@8bytes.org>
 <1246883177.2615.33.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1246883177.2615.33.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 06 Jul 2009 13:11:57.0424 (UTC) FILETIME=[57143F00:01C9FE3B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 01:26:17PM +0100, David Woodhouse wrote:
> On Fri, 2009-05-08 at 11:35 +0200, Joerg Roedel wrote:
> > The other way to achieve consistency is to remove the workaround from
> > VT-d code which significantly increases the chance to get the broken
> > stuff fixed. David?
> 
> It's gone from 2.6.31-rc2, but even the in-tree drivers break, so I
> think we have to put it back for 2.6.31 (I've sent Linus the pull
> request already). 
> 
> I do intend to remove it again for 2.6.32 though, and I filed 
> http://bugzilla.kernel.org/show_bug.cgi?id=13721
> 
> For now it's got a clearer description ("Workaround broken graphics
> drivers") and defaults to 'n'.

Ok, cool, that sounds good. Which in-kernel DRM drivers break with IOMMU
for you? I'll may probably add a similar temporary workaround for AMD
IOMMU too...

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

