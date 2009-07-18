Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbZGRSTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbZGRSTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 14:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbZGRSTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 14:19:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbZGRSTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 14:19:40 -0400
Date: Sat, 18 Jul 2009 14:19:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
       device-mapper development <dm-devel@redhat.com>,
       Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Message-ID: <20090718181921.GA8990@infradead.org>
References: <19041.4714.686158.130252@notabene.brown> <20090718043155.GI4231@webber.adilger.int> <871voewm6y.fsf@basil.nowhere.org> <20090718065213.GK4231@webber.adilger.int> <20090718074811.GA2682@basil.fritz.box> <20090718134946.GA25546@mit.edu> <20090718142156.GC2682@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090718142156.GC2682@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 04:21:56PM +0200, Andi Kleen wrote:
> > We don't have to rewrite fsck; most of the framework for supporting an
> > run-length-conding for compressed bitmaps is already in patches that
> > add > 32-bit block numbers to e2fsprogs; we've just been more focused
> > on getting 64-bit block numbers support merged than implementing
> > compressed bitmaps, but it's only one file that would need to be
> > added, and we might be able to steal the compressed bitmap support
> > from xfsprogs --- which does this already.
> 
> There are regular reports of xfs_repair failing on 32bit,
> even on volumes far smaller than 16TB.

We have a set of patches pending to reduce memory use in xfs_repair
dramaticly, replacing bitmaps for tracking used blocks with extent
structures stored in btrees.

