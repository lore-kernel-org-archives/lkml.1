Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbYIUF3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbYIUF3p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 01:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbYIUF3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 01:29:38 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:50952 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYIUF3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 01:29:37 -0400
Date: Sun, 21 Sep 2008 08:27:50 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ashok Raj <ashok.raj@intel.com>, Shaohua Li <shaohua.li@intel.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 03/23] AMD IOMMU: implement lazy IO/TLB flushing
Message-ID: <20080921052750.GM6990@il.ibm.com>
References: <1221670377-19295-4-git-send-email-joerg.roedel@amd.com> <20080918041104K.fujita.tomonori@lab.ntt.co.jp> <20080917192827.GA18515@8bytes.org> <20080918102931Z.fujita.tomonori@lab.ntt.co.jp> <20080918140350.GE24392@amd.com> <20080919174339.GA29039@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919174339.GA29039@8bytes.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 07:43:39PM +0200, Joerg Roedel wrote:
> Hi All,
> 
> FUJITA mentioned that I forgot to discuss this patch with you guys, the
> implementers and maintainers for Intel VT-d and Calgary IOMMU drivers. I
> would like to hear your opinion on that patch. He is right with that.
> The patch is already in tip/iommu but can easily be reverted if there
> are fundamental objections.
> The patch basically moves the iommu=fullflush and iommu=nofullflush
> option from the GART code to pci-dma.c. So we can use these parameters
> in other IOMMU implementations too. Since Intel VT-d is implementing
> also lazy IO/TLB flushing it would benefit from this generic parameter
> too. I am not so sure about Calgary, but we have other parameters for
> iommu= which doesn't affect all hardware IOMMUs.

Calgary can't use fullflush, but in general the more unified our IOMMU
options, the better for the users. It's a pain to have to remember
which option applies to which IOMMU implementation.

Cheers,
Muli
-- 
Workshop on I/O Virtualization (WIOV '08)
Co-located with OSDI '08, Dec 2008, San Diego, CA
http://www.usenix.org/wiov08
