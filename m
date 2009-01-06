Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbZAFXWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbZAFXWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZAFXWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:22:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60150 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbZAFXWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:22:09 -0500
Date: Tue, 6 Jan 2009 18:22:08 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Dmitri Monakhov <dmonakhov@openvz.org>,
       Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090106232208.GA25103@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106150855.5f362a2d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106150855.5f362a2d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 03:08:55PM -0800, Andrew Morton wrote:
> > Btw, this code is still not quite right.  We really need to call
> > ->setattr instead of vmtruncate here.  Complex filesystem need
> > transaction to properly free blocks, and those transactions are in
> > ->setattr not inside vmtruncate where ->truncate doesn't even have
> > a chance to get the handle to the transaction passed.
> > 
> > As these patches don't make it worse this is not a NACK, but more of
> > a heads up.
> 
> Sure.  Maybe add a FIXME comment for now?

Ok.  I was planning to look into this again, and IIRC Dave already did
when he was at SGI, but his proof of concept patches got lost somewhere.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
