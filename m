Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbZDXSNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbZDXSNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 14:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbZDXSNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 14:13:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbZDXSNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 14:13:09 -0400
Date: Fri, 24 Apr 2009 14:13:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [PATCH 0/4] Fix sys_sync() and cleanup code (version 3)
Message-ID: <20090424181308.GA8903@infradead.org>
References: <1240522536-2994-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240522536-2994-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 11:35:32PM +0200, Jan Kara wrote:
>   Hi,
> 
>   this is a next version of the patches. I've modified comments a bit
> and mainly fixed a return value of __fsync_super() (forgot to commit
> the fix before). Thanks to Trond and Christoph for useful comments.

FYI this (or rather the previous one) seems to do fine running xfsqa.

