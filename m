Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYIKSKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYIKSKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYIKSK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:10:29 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:56995 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYIKSK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:10:29 -0400
Date: Thu, 11 Sep 2008 21:10:06 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: [PATCH 1/2] x86: avoid unnecessary low zone allocation in
	Calgary's alloc_coherent
Message-ID: <20080911181006.GV6975@il.ibm.com>
References: <1221142128-28350-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1221142128-28350-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221142128-28350-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 11:08:47PM +0900, FUJITA Tomonori wrote:
> x86's common alloc_coherent (dma_alloc_coherent in dma-mapping.h) sets
> up the gfp flag according to the device dma_mask but Calgary doesn't
> need it because of virtual mappings. This patch avoids unnecessary low
> zone allocation.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Alexis Bruemmer <alexisb@us.ibm.com>
> Cc: Muli Ben-Yehuda <muli@il.ibm.com>

Looks good,

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Cheers,
Muli
-- 
Workshop on I/O Virtualization (WIOV '08)
Co-located with OSDI '08, Dec 2008, San Diego, CA
http://www.usenix.org/wiov08
