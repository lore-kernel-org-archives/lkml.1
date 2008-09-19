Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYISKko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYISKko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 06:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYISKke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 06:40:34 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:16924 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbYISKkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 06:40:33 -0400
X-BigFish: VPS-55(z21eW5edJz1454M1432R98dR936eQ1805M936fQ873fnzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K7FUYS-04-DR7-01
Date: Fri, 19 Sep 2008 12:39:23 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28
Message-ID: <20080919103923.GI24392@amd.com>
References: <20080919100711.GH24392@amd.com> <20080919192804A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080919192804A.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Sep 2008 10:39:23.0981 (UTC) FILETIME=[FB682FD0:01C91A43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 07:28:13PM +0900, FUJITA Tomonori wrote:
> On Fri, 19 Sep 2008 12:07:11 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Hi Ingo,
> > 
> > please pull the updates for the AMD IOMMU driver for the 2.6.28 merge
> > window. Most of the patches had been sent to LKML for review and got
> > comments. One patch touches the GART driver and was added after an
> > objection with a patch previously in this series. Please pull.
> > 
> > The following changes since commit 74546a8cd9a4e2c26a15a534f0be2f9cc08ae675:
> >   Ingo Molnar (1):
> >         Revert "fix warning in: "x86: HPET_MSI Initialise per-cpu HPET timers""
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-updates-2.6.28
> > 
> > FUJITA Tomonori (1):
> >       AMD IOMMU: avoid unnecessary low zone allocation in alloc_coherent
> > 
> > Joerg Roedel (24):
> >       AMD IOMMU: check for invalid device pointers
> >       AMD IOMMU: move TLB flushing to the map/unmap helper functions
> >       x86: move GART TLB flushing options to generic code
> 
> As I wrote, I don't think that this GART patch is the right approach.

I don't thinks its clean to leave nofullflush in GART code and move
fullflush to generic code only. If we move something then both. But feel
free to submit a patch that removes the nofullflush option. I would not
disagree with that.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

