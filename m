Return-Path: <linux-kernel-owner+w=401wt.eu-S935840AbZDBLSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935840AbZDBLSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763082AbZDBLSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:18:24 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:40273 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759064AbZDBLSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:18:22 -0400
X-BigFish: VPS-26(z34a4jz1432R98dR1805M936fK10d1Izz1202hzzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KHH0Q4-02-9Q3-01
Date: Thu, 2 Apr 2009 13:18:39 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: <shemminger@vyatta.com>, <davej@redhat.com>, <tglx@linuxtronix.de>,
       <mingo@redhat.com>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <x86@kernel.org>
Subject: Re: [Bug 487894] New: sky2 0000:06:00.0: DMA-API: device driver
	frees DMA memory with different size
Message-ID: <20090402111839.GE21083@amd.com>
References: <20090401172708.GA11941@redhat.com> <20090401110245.4d1ddf72@nehalam> <20090402105415.GD21083@amd.com> <20090402200634I.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090402200634I.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Apr 2009 11:18:06.0499 (UTC) FILETIME=[B2498F30:01C9B384]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 08:06:26PM +0900, FUJITA Tomonori wrote:
> On Thu, 2 Apr 2009 12:54:15 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Wed, Apr 01, 2009 at 11:02:45AM -0700, Stephen Hemminger wrote:
> > > 
> > > The sky2 driver uses pci_unmap_len and pci_unmap_len_set which on 32 bit
> > > platforms are meaningless so they are stubbed out. 
> > > Basically, DMA-API checks are wrong/bogus to enforce on 32bit x86 as is.
> > 
> > As far as I know the VT-d driver is available on 32 bit x86 too. So this should
> > not always be a nop.
> 
> VT-d is available on only x86_64.

At least there was a patch to enable it on 32 bit too. See

https://lists.linux-foundation.org/pipermail/iommu/2009-February/001080.html

It seems not to be upstream yet.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

