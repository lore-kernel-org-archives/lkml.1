Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbXJWRsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbXJWRsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXJWRr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:47:58 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:2573 "EHLO
	outbound3-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732AbXJWRr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:47:56 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Date: Tue, 23 Oct 2007 19:47:11 +0200
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86 gart: rename symbols only used for the GART
 implementation
Message-ID: <20071023174711.GC6697@amd.com>
References: <11931612933917-git-send-email-joerg.roedel@amd.com>
 <1193161293928-git-send-email-joerg.roedel@amd.com>
 <200710231943.47157.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200710231943.47157.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 23 Oct 2007 17:47:12.0486 (UTC)
 FILETIME=[BDE23860:01C8159C]
X-WSS-ID: 6B00EC282IW7779-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 07:43:47PM +0200, Andi Kleen wrote:
> On Tuesday 23 October 2007 19:41:33 Joerg Roedel wrote:
> > This patch renames the 4 symbols iommu_hole_init(), iommu_aperture,
> > iommu_aperture_allowed, iommu_aperture_disabled.
> > 
> > It replaces the iommu_ with gart_ in the symbol name. All these symbols are
> > only used for the GART implementation of IOMMUs.
> 
> That makes it still potentially conflicting with the AGP GART code.

Maybe yes. But the AGP GART driver conflicts with the GART IOMMU config
option. So I don't see a problem here.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


