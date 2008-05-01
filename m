Return-Path: <linux-kernel-owner+w=401wt.eu-S1761223AbYEAP6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761223AbYEAP6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760133AbYEAP6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:58:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38129 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYEAP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:58:44 -0400
Date: Thu, 1 May 2008 11:58:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       John Linville <linville@tuxdriver.com>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add API for weak DMA masks
Message-ID: <20080501155826.GA11188@infradead.org>
References: <200805011638.15910.mb@bu3sch.de> <200805011742.05302.mb@bu3sch.de> <20080501154358.GA3318@infradead.org> <200805011747.27469.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805011747.27469.mb@bu3sch.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 05:47:26PM +0200, Michael Buesch wrote:
> We've discussed that and this behaviour is not acceptable, as the driver
> must know about a possible fallback in case it can do 32bit DMA
> more efficiently than 64bit DMA, for example.

That's what we have dma_get_required_mask() for.  See
Documentation/DMA-API.txt.

