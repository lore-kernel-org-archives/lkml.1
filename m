Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbXJXBlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbXJXBlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXJXBk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:40:56 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:19531 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbXJXBk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:40:56 -0400
Date: Tue, 23 Oct 2007 21:18:41 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86 gart: rename symbols only used for the GART	implementation
Message-ID: <20071023191841.GF4360@rhun.haifa.ibm.com>
References: <11931612933917-git-send-email-joerg.roedel@amd.com> <20071023175908.GD7793@redhat.com> <471E37B4.9010604@zytor.com> <200710232010.55074.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710232010.55074.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 08:10:54PM +0200, Andi Kleen wrote:

> I think his goal was to get an prefix that describes the module
> uniquely.  gart_* clearly does not fulfill that criteria.
> 
> So basically he's replacing an
> ambigious-with-other-IOMMU-implementations prefix with an
> ambigious-with-AGP prefix. Seems like a rather pointless change.

Not at all - the present situation where GART specific code
masquerades as generic IOMMU code is confusing. I've heard from more
than one person who was confused by "how come I can enable an IOMMU
while CONFIG_IOMMU is off?" and "how come some iommu_xxx options
(which were really gart options...) don't actually affect the
(Calgary) IOMMU"?

If the variable names clash the correct solution is to s/gart/agpgart/
in the AGP code and then continue renaming gart specific bits 'gart'
rather than 'iommu'.

Cheers,
Muli
-- 
SYSTOR 2007 --- 1st Annual Haifa Systems and Storage Conference 2007
http://www.haifa.il.ibm.com/Workshops/systor2007/

Virtualization workshop: Oct 29th, 2007 | Storage workshop: Oct 30th, 2007
