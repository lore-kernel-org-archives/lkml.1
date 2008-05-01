Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbYEAPgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbYEAPgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbYEAPgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:36:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50667 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbYEAPgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:36:38 -0400
Date: Thu, 1 May 2008 11:36:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       John Linville <linville@tuxdriver.com>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add API for weak DMA masks
Message-ID: <20080501153618.GA470@infradead.org>
References: <200805011638.15910.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805011638.15910.mb@bu3sch.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 04:38:15PM +0200, Michael Buesch wrote:
> This patchset adds API and one user for a "weak" dma_set_mask().
> Weak means that it will fallback to smaller masks in case the
> DMA subsystem rejects a big mask.
> Currently such rejection may happen if the driver requests a 64bit
> mask on a VIA machine, for example. dma_set_mask_weak() will fallback
> to 32bit, in that case, and tell the caller about it by modifying the
> passed mask.

Why do we need it?  Is the call to set the 32bit mask when it fails
a too big burden for the driver author?

