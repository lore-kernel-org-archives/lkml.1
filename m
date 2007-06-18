Return-Path: <linux-kernel-owner+w=401wt.eu-S1765564AbXFRSn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765564AbXFRSn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764599AbXFRSnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:43:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58969 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761290AbXFRSnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:43:45 -0400
Date: Mon, 18 Jun 2007 19:43:43 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, xfs-masters@oss.sgi.com
Subject: Re: [PATCH] XFS:  Replace remaining memclear_highpage_flush() with zero_user_page().
Message-ID: <20070618184343.GB17479@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, xfs-masters@oss.sgi.com
References: <Pine.LNX.4.64.0706181154090.26616@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706181154090.26616@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 11:59:30AM -0400, Robert P. J. Day wrote:
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   this appears to be the final occurrence of that deprecated call in
> the entire tree which suggests that, if you're not concerned about
> out-of-tree modules, that definition could also be removed from
> include/linux/highmem.h:
> 
> static inline void __deprecated memclear_highpage_flush(struct page *page,
>                         unsigned int offset, unsigned int size)
> {
>         zero_user_page(page, offset, size, KM_USER0);
> }

Andrew, please send this and the memclear_highpage_flush removal to Linus
for 2.6.22-rc.  The warning is really highly annoying and utterly pointless.
