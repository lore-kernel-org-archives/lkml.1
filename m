Return-Path: <linux-kernel-owner+w=401wt.eu-S1759199AbZFQJ0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbZFQJ0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZFQJ0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:26:42 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:8502 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZFQJ0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:26:41 -0400
X-SpamScore: -32
X-BigFish: VPS-32(zz1432R98dR1447R1805Mzz1202hzzz32i6bh17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KLDM7S-04-33T-01
Date: Wed, 17 Jun 2009 11:26:29 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: dma-debug warning with ixgbe
Message-ID: <20090617092629.GP5139@amd.com>
References: <20090616153417.GN5139@amd.com> <alpine.WNT.2.00.0906160907580.6076@jbrandeb-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <alpine.WNT.2.00.0906160907580.6076@jbrandeb-desk1.amr.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 17 Jun 2009 09:26:29.0877 (UTC) FILETIME=[B22F2250:01C9EF2D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 09:33:15AM -0700, Brandeburg, Jesse wrote:
> On Tue, 16 Jun 2009, Joerg Roedel wrote:
> > today I got this dma-debug warning with the ixgbe driver with a kernel
> > near 2.6.30-rc8.
> 
> Hi Joerg, thanks for the report, I thought we had fixed all of these 
> already but we must have missed this one.
> 
> > ------------[ cut here ]------------
> > WARNING: at /data/repos/linux-2.6-iommu/lib/dma-debug.c:806
> > check_unmap+0x214/0x5c3()
> > Hardware name: Toonie
> > ixgbe 0000:02:00.0: DMA-API: device driver frees DMA memory with
> > different size [device address=0x0000000000045c12] [map size=258
> > bytes] [unmap size=256 bytes]
> 
> The following patch should fix it, compile tested only, but it is pretty 
> straight forward.

Thanks for the quick answer :) But I tested the patch and the warning is
still there.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

