Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbYG3MT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbYG3MT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbYG3MTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:19:17 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:59530 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbYG3MTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:19:16 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K4TJJN-03-GR3-01
Date: Wed, 30 Jul 2008 14:18:05 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-ID: <20080730121805.GM4851@amd.com>
References: <20080728.222439.176200666.davem@davemloft.net> <20080729164523.bfd2d539.sfr@canb.auug.org.au> <20080729095027.GA4851@amd.com> <20080729.031005.203132019.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080729.031005.203132019.davem@davemloft.net>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 30 Jul 2008 12:18:06.0223 (UTC) FILETIME=[524559F0:01C8F23E]
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

Ok, after setting up cross compile environments for sparc64 and
powerpc64 I wrote a patch which adds the io_page_size argument to the
iommu_num pages function and moves the function back to
lib/iommu-helper.c. The patch touches all 3 architectures and can not be
split in a bisectable way.

Who is the best person to send this patch to?

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

