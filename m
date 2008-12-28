Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbYL1Jgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbYL1Jgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 04:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYL1Jg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 04:36:28 -0500
Received: from sh.osrg.net ([192.16.179.4]:55066 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbYL1Jg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 04:36:27 -0500
Date: Sun, 28 Dec 2008 18:36:10 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, jeremy@goop.org, joerg.roedel@amd.com,
       beckyb@kernel.crashing.org
Subject: Re: [PATCH 0/3] swiotlb cleanups
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081228090537.GA9022@elte.hu>
References: <1230444127-587-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20081228090537.GA9022@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081228183522O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Dec 2008 10:05:37 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > This is minor swiotlb cleanups. It depends on the swiotlb highmem
> > patchset:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git swiotlb
> 
> thanks, applied them to tip/core/iommu - after Becky's patchset as ported 
> by Jeremy.

Thanks,

The log of tip/core/iommu looks really wired. Two patches claim to add
highmem support to swioblb. Becky completely reverts the Jeremy's and
does in a different way without any description.

As I wrote, I recommend you to reorder the patches. There is no point
to merge Jeremy's highmem patch.

