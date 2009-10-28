Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZJ1Njn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZJ1Njn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 09:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbZJ1Njn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 09:39:43 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:38517 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbZJ1Njm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 09:39:42 -0400
Date: Wed, 28 Oct 2009 15:38:42 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       joerg.roedel@amd.com, mingo@elte.hu
Subject: Re: [PATCH 02/10] Calgary: convert detect_calgary to use
	iommu_init hook
Message-ID: <20091028133842.GP7133@il.ibm.com>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1256712464-21472-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256712464-21472-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 03:47:36PM +0900, FUJITA Tomonori wrote:
> This changes detect_calgary() to set init_calgary() to iommu_init hook
> if detect_calgary() finds the Calgary IOMMU.
> 
> We can kill the code to check if we found the IOMMU in init_calgary()
> since detect_calgary() sets init_calgary() only when it found the
> IOMMU.

I like this patchset a lot. Our with the old cruft!

> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Cheers,
Muli
