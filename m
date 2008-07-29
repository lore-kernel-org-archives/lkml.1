Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbYG2K1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbYG2K1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbYG2K1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:27:13 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:34307 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbYG2K1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:27:11 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K4RJOY-04-C60-01
Date: Tue, 29 Jul 2008 12:26:55 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-ID: <20080729102655.GC4851@amd.com>
References: <20080728.222439.176200666.davem@davemloft.net> <20080729164523.bfd2d539.sfr@canb.auug.org.au> <20080729095027.GA4851@amd.com> <20080729.031005.203132019.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080729.031005.203132019.davem@davemloft.net>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 29 Jul 2008 10:26:56.0001 (UTC) FILETIME=[A0187F10:01C8F165]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 03:10:05AM -0700, David Miller wrote:
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Tue, 29 Jul 2008 11:50:27 +0200
> 
> > I think moving that function to x86-only code is the best solution for
> > now. Before moving it back to generic code we need an architecture
> > independent way to find out the IOMMU page size.
> 
> My suggestion (again) is to pass it in as a "const unsigned long
> io_page_size" argument and update the callers.

Ok, this has the advantage that it supports more than one IOMMU page
size per architecture and its also less intrusive.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

