Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZHJNtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZHJNtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 09:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZHJNtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 09:49:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbZHJNtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 09:49:52 -0400
Date: Mon, 10 Aug 2009 09:49:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       msb@google.com, viro@zeniv.linux.org.uk, hannes@cmpxchg.org
Subject: Re: [PATCH 1/3] vfs: make get_sb_pseudo set s_maxbytes to value
	that can be cast to signed
Message-ID: <20090810134950.GA16276@infradead.org>
References: <1249906663-7572-1-git-send-email-jlayton@redhat.com> <1249906663-7572-2-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249906663-7572-2-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 08:17:41AM -0400, Jeff Layton wrote:
> get_sb_pseudo sets s_maxbytes to ~0ULL which becomes negative when cast
> to a signed value. Fix it to use MAX_LFS_FILESIZE which casts properly
> to a positive signed value.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Steve French <smfrench@gmail.com>

Looks good, and I think it would be very good to still gets this into
2.6.31.

Reviewed-by: Christoph Hellwig <hch@lst.de>

