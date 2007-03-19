Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbXCSJWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbXCSJWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbXCSJWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:22:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41031 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbXCSJWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:22:24 -0400
Date: Mon, 19 Mar 2007 09:22:22 +0000
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
Message-ID: <20070319092222.GA1720@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	nickpiggin@yahoo.com.au
References: <20070318233008.GA32597093@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318233008.GA32597093@melbourne.sgi.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 10:30:08AM +1100, David Chinner wrote:
> 
> Generic page_mkwrite functionality.
> 
> Filesystems that make use of the VM ->page_mkwrite() callout will generally use
> the same core code to implement it. There are several tricky truncate-related
> issues that we need to deal with here as we cannot take the i_mutex as we
> normally would for these paths.  These issues are not documented anywhere yet
> so block_page_mkwrite() seems like the best place to start.

This will need some updates when ->fault replaces ->page_mkwrite.

Nich, what's the plan for merging ->fault?

