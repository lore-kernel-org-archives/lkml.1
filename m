Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbYGYOdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbYGYOdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYGYOdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:33:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:39136 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbYGYOdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:33:25 -0400
Date: Fri, 25 Jul 2008 23:32:55 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com
Subject: Re: [PATCH] add iommu_num_pages helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080725141425.GB7493@amd.com>
References: <20080725134159.GA7493@amd.com>
	<20080725225724J.fujita.tomonori@lab.ntt.co.jp>
	<20080725141425.GB7493@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080725233325W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 16:14:25 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> > > If not, I suggest that we (you?) introduce one in a follow-on patch
> > > series and fix the iommu_num_pages function then.
> > 
> > That's fine by me. Or I could try to find a solution and submit new
> > patchset with your AMD and GART patches.
> 
> Thats also possible. But I prefer to fix that incrementally and merge
> this first step.
> 
> > BTW, I prefer to push this patchset via -mm rather than x86 since
> > after all we need to clean up all the IOMMUs.
> 
> Push it through -mm would make sense since it touches generic code in
> lib/. On the other side in x86 we would avoid merge conflicts with
> updates in AMD IOMMU and GART code.

Ok, I have no preference. It's not urgent and I can work on this later
on. I leave it to you and x86 maintainers.

Thanks,
