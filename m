Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbYG2KDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbYG2KDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbYG2KDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:03:00 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:10358 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbYG2KC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:02:59 -0400
X-BigFish: VPS-5(zz1432R98dR1805M936fQ873fnzz10d3izz3198u327anz32i6bh43j)
X-FB-SS: 13,
X-WSS-ID: 0K4RIKG-04-BAB-01
Date: Tue, 29 Jul 2008 12:02:33 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: sfr@canb.auug.org.au, davem@davemloft.net, mingo@elte.hu, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-ID: <20080729100233.GB4851@amd.com>
References: <20080728.222439.176200666.davem@davemloft.net> <20080729164523.bfd2d539.sfr@canb.auug.org.au> <20080729095027.GA4851@amd.com> <20080729185838W.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080729185838W.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 29 Jul 2008 10:02:33.0710 (UTC) FILETIME=[388098E0:01C8F162]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 06:58:08PM +0900, FUJITA Tomonori wrote:
> On Tue, 29 Jul 2008 11:50:27 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> > do you want to work on that or should I try to do this and send it to
> > you for review?
> 
> I've already sent a patch that fixes the breakages in such way:
> 
> http://marc.info/?l=linux-kernel&m=121730644704448&w=2

Yes I have seen this patch. I meant the patches that introduce something
like IOMMU_PAGE_SIZE for all architectures so that we can make this
function generic and move it back to lib/.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

