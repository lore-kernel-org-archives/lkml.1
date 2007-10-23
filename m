Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbXJWTGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbXJWTGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXJWTF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:05:59 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:18836 "EHLO
	mail39-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbXJWTF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:05:58 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Tue, 23 Oct 2007 21:05:03 +0200
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: "H. Peter Anvin" <hpa@zytor.com>, "Dave Jones" <davej@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86 gart: rename symbols only used for the GART
 implementation
Message-ID: <20071023190503.GD6697@amd.com>
References: <11931612933917-git-send-email-joerg.roedel@amd.com>
 <20071023175908.GD7793@redhat.com> <471E37B4.9010604@zytor.com>
 <200710232010.55074.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200710232010.55074.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 23 Oct 2007 19:05:03.0319 (UTC)
 FILETIME=[9DEAC670:01C815A7]
X-WSS-ID: 6B0099880QK16137-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 08:10:54PM +0200, Andi Kleen wrote:
> On Tuesday 23 October 2007 20:04:36 H. Peter Anvin wrote:
> > Dave Jones wrote:
> > > On Tue, Oct 23, 2007 at 07:47:11PM +0200, Joerg Roedel wrote:
> > >  > On Tue, Oct 23, 2007 at 07:43:47PM +0200, Andi Kleen wrote:
> > >  > > On Tuesday 23 October 2007 19:41:33 Joerg Roedel wrote:
> > >  > > > This patch renames the 4 symbols iommu_hole_init(), iommu_aperture,
> > >  > > > iommu_aperture_allowed, iommu_aperture_disabled.
> > >  > > > 
> > >  > > > It replaces the iommu_ with gart_ in the symbol name. All these symbols are
> > >  > > > only used for the GART implementation of IOMMUs.
> > >  > > 
> > >  > > That makes it still potentially conflicting with the AGP GART code.
> > >  > 
> > >  > Maybe yes. But the AGP GART driver conflicts with the GART IOMMU config
> > >  > option. So I don't see a problem here.
> > >  
> > > It shouldn't.  It's perfectly feasible to use both IOMMU and GART for AGP at
> > > the same time.
> > > 
> > 
> > And even if did, it's a big difference between being not able to compile 
> > in two drivers in the same kernel and not being able to use them at the 
> > same time.
> 
> You can already compile them in all. The functions are not really
> conflicting -- otherwise allyesconfig would not work.
> 
> I think his goal was to get an prefix that describes the module uniquely.
> gart_* clearly does not fulfill that criteria.
> 
> So basically he's replacing an ambigious-with-other-IOMMU-implementations
> prefix with an ambigious-with-AGP prefix. Seems like a rather pointless
> change.

Ok, sorry, right. I misunderstood the Kconfig entry for the AGP GART
driver. I will change the prefix to gart_iommu and resubmit.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


