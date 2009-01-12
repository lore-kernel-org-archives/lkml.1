Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbZALUXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbZALUXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZALUXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:23:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45666 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbZALUXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:23:42 -0500
Date: Mon, 12 Jan 2009 15:23:36 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090112202336.GB27636@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151915.df138883.akpm@linux-foundation.org> <20090108191152.GU15123@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108191152.GU15123@enneenne.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 08:11:53PM +0100, Rodolfo Giometti wrote:
> With "kernel-doc" do you mean what explained into
> Documentation/kernel-doc-nano-HOWTO.txt file?

Yes.

> > > pps.h shoulkd be split into one header only defining the
> > > kernel<->userspace ABI, and a kernel-internal one.  That way
> > > also the conditional includes can go away.
> 
> I don't understand well what I should do here... I supposed __KERNEL__
> define was defined to allow mixing kernel and userland code.

Yes, __KERNEL__ works, but it's still better to just keep things
entirely separate.

