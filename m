Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZGBKCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZGBKCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZGBKBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:01:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZGBKBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:01:52 -0400
Date: Thu, 2 Jul 2009 06:01:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: William Cohen <wcohen@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add block IO documentation to tracepoint docbook
Message-ID: <20090702100155.GA28662@infradead.org>
References: <4A4BBECD.8000908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4BBECD.8000908@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 03:53:49PM -0400, William Cohen wrote:
> +/**
> + * block_rq_abort - Abort Block Operation Request
> + * @q: queue containing the block operation request
> + * @rq: block IO operation request
> + *
> + * Called immediately after pending block IO operation request @rq in
> + * queue @q is aborted. The fields in the operation request @rq
> + * can be examined to determine which device and sectors the pending
> + * operation would access.
> + */
>  TRACE_EVENT(block_rq_abort,

Um, what's the point?  These are not function, but rather trace points.
The paramters don't actually get exported in the trace files, but the
printk ring buffer format and the format string do.  So please document
the formats, and if possible make sure this documentation actually
appears in debugfs in the trace subdirectory so people get it very easily.

