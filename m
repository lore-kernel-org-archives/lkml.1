Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbZFJIbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbZFJIbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbZFJIbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:31:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36158 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZFJIbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:31:38 -0400
Date: Wed, 10 Jun 2009 04:31:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel@vger.kernel.org
Subject: Re: linux-next: next-20090609 hangs in early user mode
Message-ID: <20090610083139.GA25538@infradead.org>
References: <20090610180058.99bd3dda.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610180058.99bd3dda.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 06:00:58PM +1000, Stephen Rothwell wrote:
> The machines are PowerPC64 (so big endian).  It looks to me like we use
> bitops on i_state - don't our bitops only apply to unsigned longs?

Yes, bitops need unsigned long.  And on most plaforms should give you
warnings when using them on the wrong type.

