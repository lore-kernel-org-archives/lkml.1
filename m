Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYGAHb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYGAHb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYGAHbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:31:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38234 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYGAHbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:31:46 -0400
Date: Tue, 1 Jul 2008 03:31:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] (resend) reuse xxx_fifo_fops for xxx_pipe_fops
Message-ID: <20080701073142.GA30362@infradead.org>
References: <200807011103.02974.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807011103.02974.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 11:03:02AM +0200, Denys Vlasenko wrote:
> Hi Andrew, Al,
> 
> I posted this patch a few months ago, but it apparently
> fell thru cracks. Here we go again.
> 
> I noticed that read/write/rdwr_pipe_fops are (1) const and
> (2) exactly identical to xxx_fifo_fops, which are also const.
> 
> Attached patch #defines xxx_pipe_fops as aliases to xxx_fifo_fops.
> Size difference:

Why do you need the #defines?  Just use the _fifo_ name directly.

