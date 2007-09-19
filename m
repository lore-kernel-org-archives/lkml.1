Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbXISR00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbXISR00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbXISR0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:26:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44111 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbXISR0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:26:18 -0400
Date: Wed, 19 Sep 2007 18:26:11 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 01/24] filesystem helpers for custom 'struct file's
Message-ID: <20070919172611.GA20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182718.A6B9F7FD@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182718.A6B9F7FD@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:18AM -0700, Dave Hansen wrote:
> 
> Christoph H. says this stands on its own and can go in before the
> rest of the r/o bind mount set.  
> 
> ---
> 
> Some filesystems forego the vfs and may_open() and create their
> own 'struct file's.
> 
> This patch creates a couple of helper functions which can be
> used by these filesystems, and will provide a unified place
> which the r/o bind mount code may patch.
> 
> Also, rename an existing, static-scope init_file() to a less
> generic name.

Looks good.  But please provide a patch ontop of your patchkit to
add kernel-doc comments for the two new exported functions.

Are there any direct caller of get_empty_filp left after this patch?
We really should get rid of that export to stop people from shooting
themselves in the foot.

