Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbZHJOQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbZHJOQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZHJOQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:16:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34770 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbZHJOQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:16:30 -0400
Date: Mon, 10 Aug 2009 10:16:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rlove@google.com, msb@google.com, viro@zeniv.linux.org.uk,
       hannes@cmpxchg.org
Subject: Re: [PATCH 1/3] vfs: make get_sb_pseudo set s_maxbytes to value
	that can be cast to signed
Message-ID: <20090810141631.GA890@infradead.org>
References: <1249906663-7572-1-git-send-email-jlayton@redhat.com> <1249906663-7572-2-git-send-email-jlayton@redhat.com> <20090810134950.GA16276@infradead.org> <20090810100818.3c17def9@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810100818.3c17def9@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 10:08:18AM -0400, Jeff Layton wrote:
> Agreed. The other two should probably go in early 2.6.32 (assuming
> they're ok).

Exactly.

