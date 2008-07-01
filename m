Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbYGAIQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbYGAIQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYGAIPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:15:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51607 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYGAIPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:15:43 -0400
Date: Tue, 1 Jul 2008 04:15:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] (resend) reuse xxx_fifo_fops for xxx_pipe_fops
Message-ID: <20080701081540.GA20332@infradead.org>
References: <200807011103.02974.vda.linux@googlemail.com> <20080701003255.493f54e0.akpm@linux-foundation.org> <200807011203.50632.vda.linux@googlemail.com> <20080701011045.f4490332.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701011045.f4490332.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 01:10:45AM -0700, Andrew Morton wrote:
> On Tue, 1 Jul 2008 12:03:50 +0200 Denys Vlasenko <vda.linux@googlemail.com> wrote:
> 
> > I think since XXX_pipe_fops are only used in this file,
> > just explaining this in the comment would be enough.
> 
> no, a comment is only needed when the code is unobvious.  Make
> the code obvious and we don't need a comment.
> 
> As Christoph pointed out, open-coding shared_read_fops everywhere
> might make sense too.  It'd make it harder to unshare them later
> on, but that's pretty improbable.

Deny's latest patch doesn't have the #defines anymore and looks quite
reasonable to me.  If you really insist on magic naming I think shared
is a very bad choice because it doesn't have any useful meaning in this
context.  If you insist on magic naming do _pipefifo_, but I think
the current version with the comment is much better.
