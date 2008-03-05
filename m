Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbYCEPpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbYCEPpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYCEPpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:45:19 -0500
Received: from colo.lackof.org ([198.49.126.79]:59761 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbYCEPpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:45:18 -0500
Date: Wed, 5 Mar 2008 08:45:02 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, tomof@acm.org,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 0/3] fix iommu segment boundary problems (parisc)
Message-ID: <20080305154502.GA32538@colo.lackof.org>
References: <1204438228-4564-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204438228-4564-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 03:10:25PM +0900, FUJITA Tomonori wrote:
> This patchset is another sequel to my patchset to fix iommu segment
> boundary problems, IOMMUs allocate memory areas without considering a
> low level driver's segment boundary limits:
> 
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg11919.html
> 
> This patchset fixes the PARISC IOMMU code (sbc and ccio).
> 
> There are three patches in this patchset. The first patch is for the
> IOMMU helper (lib/iommu-helper.c) to enable PARISC IOMMUs use it.
> 
> The second and third patches are for PARISC IOMMUs, the second one is
> preparation for the third patch, which fixes the IOMMU segment
> boundary problem.
> 
> The third patch assumes that ioc->ibase is on IOVP_SIZE boundary. If
> not, please let me know. I'll fix the patch.

Please add
    Acked-by: Grant Grundler <grundler@parisc-linux.org>

This includes the 4th patch posted on march 3, 2008.

Thanks for posting this series. I've reviewed the code and it looks fine
to me as well (kyle already acked it).

And thanks to Joel Soete (rubisher) for testing. I tried to test the
sba_iommu code on my local box but had issues with the unpatched kernel
(using kyle's parisc-2.6.git tree) that I have yet to resolve (could be
HW problems).

thanks,
grant
