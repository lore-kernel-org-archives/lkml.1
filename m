Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbZGHSLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbZGHSLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZGHSLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:11:05 -0400
Received: from verein.lst.de ([213.95.11.210]:55522 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbZGHSLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:11:04 -0400
Date: Wed, 8 Jul 2009 20:10:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: don't bounce highmem requests
Message-ID: <20090708181053.GA10552@lst.de>
References: <20090619182022.GA10999@lst.de> <20090620183215.GA24936@lst.de> <200906231642.52848.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906231642.52848.rusty@rustcorp.com.au>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 04:42:52PM +0930, Rusty Russell wrote:
> On Sun, 21 Jun 2009 04:02:15 am Christoph Hellwig wrote:
> > Looks like I sent a patch that doesn't actually compile because qui
> > decided to apply those fixes to a different one.  Here's the correc
> > one:
> >
> > --
> >
> > Subject: virtio_blk: don't bounce highmem requests
> > From: Christoph Hellwig <hch@lst.de>
> >
> > By default a block driver bounces highmem requests, but virtio-blk is
> > perfectly fine with any request that fit into it's 64 bit addressing
> > scheme, mapped in the kernel virtual space or not.
> 
> Thanks, applied.

Can you forward it to Linus for 2.6.31?  It's a trivial fix for an issue
causing a lot of pain to people with highmem enabled.

