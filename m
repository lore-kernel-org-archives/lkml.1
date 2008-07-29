Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbYG2Jv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbYG2Jv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbYG2Jux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:50:53 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4444 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500AbYG2Juu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:50:50 -0400
X-BigFish: VPS-24(zz1432R98dR1805M936fQ873fnzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K4RI03-04-AVT-01
Date: Tue, 29 Jul 2008 11:50:27 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-ID: <20080729095027.GA4851@amd.com>
References: <20080729110749.728c54e6.sfr@canb.auug.org.au> <20080729104722H.fujita.tomonori@lab.ntt.co.jp> <20080729135652.f89042c1.sfr@canb.auug.org.au> <20080728.222439.176200666.davem@davemloft.net> <20080729164523.bfd2d539.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080729164523.bfd2d539.sfr@canb.auug.org.au>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 29 Jul 2008 09:50:27.0677 (UTC) FILETIME=[87C0C0D0:01C8F160]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 04:45:23PM +1000, Stephen Rothwell wrote:
> Hi Dave,
> 
> On Mon, 28 Jul 2008 22:24:39 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> >
> > sparc64: Fix build after addition of iommu_num_pages() helper.
> 
> I added this to the end of linux-next for today.  Hopefully we will have
> a fix in Linus' tree tomorrow.

Yes, my fault, sorry for that breakage :-/
I think moving that function to x86-only code is the best solution for
now. Before moving it back to generic code we need an architecture
independent way to find out the IOMMU page size.

FUJITA,

do you want to work on that or should I try to do this and send it to
you for review?

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

