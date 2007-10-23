Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbXJWR7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbXJWR7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXJWR7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:59:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbXJWR7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:59:24 -0400
Date: Tue, 23 Oct 2007 13:59:08 -0400
From: Dave Jones <davej@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86 gart: rename symbols only used for the GART
	implementation
Message-ID: <20071023175908.GD7793@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>, Andi Kleen <ak@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
References: <11931612933917-git-send-email-joerg.roedel@amd.com> <1193161293928-git-send-email-joerg.roedel@amd.com> <200710231943.47157.ak@suse.de> <20071023174711.GC6697@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023174711.GC6697@amd.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 07:47:11PM +0200, Joerg Roedel wrote:
 > On Tue, Oct 23, 2007 at 07:43:47PM +0200, Andi Kleen wrote:
 > > On Tuesday 23 October 2007 19:41:33 Joerg Roedel wrote:
 > > > This patch renames the 4 symbols iommu_hole_init(), iommu_aperture,
 > > > iommu_aperture_allowed, iommu_aperture_disabled.
 > > > 
 > > > It replaces the iommu_ with gart_ in the symbol name. All these symbols are
 > > > only used for the GART implementation of IOMMUs.
 > > 
 > > That makes it still potentially conflicting with the AGP GART code.
 > 
 > Maybe yes. But the AGP GART driver conflicts with the GART IOMMU config
 > option. So I don't see a problem here.
 
It shouldn't.  It's perfectly feasible to use both IOMMU and GART for AGP at
the same time.

	Dave

-- 
http://www.codemonkey.org.uk
