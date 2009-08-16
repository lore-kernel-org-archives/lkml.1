Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386AbZHPNxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbZHPNxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 09:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZHPNxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 09:53:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZHPNxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 09:53:15 -0400
Date: Sun, 16 Aug 2009 09:53:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mark Lord <liml@rtr.ca>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH, RFC] xfs: batched discard support
Message-ID: <20090816135315.GA25251@infradead.org>
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca> <4A876CA9.20906@rtr.ca> <20090816022500.GA12392@infradead.org> <4A8802F3.6010908@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8802F3.6010908@rtr.ca>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 09:00:35AM -0400, Mark Lord wrote:
> Okay, this gives me ENOSYS now --> discard/trim support is missing from
> the lower layers.

ENOSYS or EOPNOTSUPP?

> What other patches do I need to make this work?
>
> The latest from Matthew's discard tree (May 2009) don't appear to be sufficient,
> even after updating them for 2.6.31-rc6.

Hmm.  That was kinda the reason why I didn't want to post stuff yet.  In
current mainline only MTD implements the prepare_discard_fn, and we'll
need it implemented and working.  I think Matthews patches should be
sufficient, unless they have some ATA revision check to not issue the
TRIM for your device.

