Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbZC3XCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbZC3XCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 19:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZC3XCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 19:02:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:46671 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZC3XCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 19:02:07 -0400
Subject: Re: [patch 0/4] Intel IOMMU Supspend/Resume Support
From: David Woodhouse <dwmw2@infradead.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Andrew Lutomirski <amluto@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       IOMMU <iommu@lists.linux-foundation.org>
In-Reply-To: <20090327212241.234500000@intel.com>>
References: <20090327212241.234500000@intel.com>>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 00:01:42 +0100
Message-Id: <1238454102.25797.284.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 14:22 -0700, Fenghua Yu wrote:
> Current Intel IOMMU does not support suspend and resume. In S3 event, kernel
> crashes when DMAR or interrupt remapping is running.
> 
> The attached patch set implements the suspend and resume feature for Intel
> IOMMU. It hooks to kernel suspend and resume interface. When suspend happens, itsaves necessary hardware registers. When resume happens, it restores the
> registers and restarts IOMMU.
> 
> This patch set can be applied on the tip tree. 

Looks good to me, apart from the fact that your #4 patch actually needs
to come before #1. Shall I apply it to my iommu-2.6.git tree or let Ingo
take it? If the latter, 

Acked-by: David Woodhouse <David.Woodhouse@intel.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>

(if you look carefully, you'll see those are in order 4, 1, 2, 3)

Have we tested this on IA64?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

