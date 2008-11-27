Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbYK0RGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbYK0RGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 12:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYK0RGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 12:06:08 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:5373 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYK0RGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 12:06:07 -0500
X-BigFish: VPS-28(z1033iz1432R98dR1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KB04TS-04-EOP-01
Date: Thu, 27 Nov 2008 18:05:55 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, weidong.han@intel.com,
       mingo@redhat.com, dwmw2@infradead.org, amit.shah@redhat.com
Subject: Re: [PATCH 1/9] KVM: rename vtd.c to iommu.c
Message-ID: <20081127170555.GN1386@amd.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com> <1227800454-9555-2-git-send-email-joerg.roedel@amd.com> <492ECBB8.6070509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <492ECBB8.6070509@redhat.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 27 Nov 2008 17:05:55.0730 (UTC) FILETIME=[6944FF20:01C950B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 06:32:56PM +0200, Avi Kivity wrote:
> Joerg Roedel wrote:
> >Impace: file renamed
> >
> >  
> 
> "impact"?

Yeah, patches for x86 should have such a line in the description. I just
added it here too because of the many x86-patches I did in the last
time. Depending on the way this will be merged I can remove the line
from the description.

> 
> >The code in the vtd.c file can be reused for other IOMMUs as well. So
> >rename it to make it clear that it handle more than VT-d.
> >
> >Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> >---
> > arch/ia64/kvm/Makefile |    2 +-
> > arch/x86/kvm/Makefile  |    2 +-
> > virt/kvm/iommu.c       |  191 ++++++++++++++++++++++++++++++++++++++++++++++++
> > virt/kvm/vtd.c         |  191 ------------------------------------------------
> >  
> 
> Use the git -M switch, which show renames as renames instead of removes+adds.

Ok, will do this in the next post

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

