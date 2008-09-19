Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbYISWK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbYISWK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 18:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYISWKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 18:10:15 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:8513 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYISWKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 18:10:14 -0400
X-BigFish: VPS-23(z1039oz1432R98dR1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K7GQW7-03-4MN-01
Date: Sat, 20 Sep 2008 00:09:46 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic option
Message-ID: <20080919220946.GB11410@amd.com>
References: <20080919195216.GB10692@amd.com> <20080920050229Z.fujita.tomonori@lab.ntt.co.jp> <20080919201909.GC10692@amd.com> <20080920065630N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080920065630N.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Sep 2008 22:09:46.0268 (UTC) FILETIME=[6D0395C0:01C91AA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 06:56:21AM +0900, FUJITA Tomonori wrote:
> 
> Because you did things int the wrong way, I said again and again.
> 
> I can't see why you refuse to do the things in the proper way.
> 
> 
> > objections agains the generic iommu=fullflush come up. The patch does
> > not break anything and just moves the iommu=flush parameter (which is
> > already available) to pci-dma.c to make it useable by AMD IOMMU too.
> 
> Breaking anything does mean that it's fine. My patch doesn't break
> anything too.
> 
> I'm not against fullflush (as I said again and again). I guess that
> it's the right move though it might be not so useful if VT-d doesn't
> support it.
> 
> I'm against totally pointless nofullflush and the way you changed the
> generic IOMMU code.

Then submit a patch that changes it to the version you prefer. I already
said that I am fine with the removal of nofullflush. But completly
reverting is the wrong way. For AMD IOMMU I want to use the
iommu=fullflush way because I want to reuse a parameter thats already
there. Thats why I am against your reverting patch.
So now I stop repeating my points again and again. EOD.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

