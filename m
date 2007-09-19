Return-Path: <linux-kernel-owner+w=401wt.eu-S1763000AbXISRgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763000AbXISRgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762082AbXISRfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:35:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58994 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762835AbXISRfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:35:03 -0400
Date: Wed, 19 Sep 2007 18:35:01 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 13/24] elevate write count for file_update_time()
Message-ID: <20070919173501.GM20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182735.ED143E7B@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182735.ED143E7B@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok.

> +	/*
> +	 * Ideally, we want to guarantee that 'f_vfsmnt'
> +	 * is non-NULL here.  But, NFS exports need to
> +	 * be fixed up before we can do that.  So, check
> +	 * it for now. - Dave Hansen
> +	 */

FYI: I have a patch to fix up nfsd, but there are more suckers around,
e.g. reiserfs xattr crapola.

