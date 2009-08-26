Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZHZV1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZHZV1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZHZV1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:27:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51116 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZHZV1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:27:35 -0400
Date: Wed, 26 Aug 2009 17:27:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30.4 loop(..?) regression (& with/2.6.31-rc6)
Message-ID: <20090826212732.GA18124@infradead.org>
References: <alpine.DEB.2.00.0908221044420.30321@p34.internal.lan> <20090822201558.GA17955@infradead.org> <alpine.DEB.2.00.0908221645440.20848@p34.internal.lan> <20090822205502.GA18904@infradead.org> <alpine.DEB.2.00.0908221659030.23463@p34.internal.lan> <20090823224504.GA19942@infradead.org> <alpine.DEB.2.00.0908240704130.9427@p34.internal.lan> <alpine.DEB.2.00.0908260949550.9396@p34.internal.lan> <20090826180234.GC14019@infradead.org> <alpine.DEB.2.00.0908261717001.1594@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908261717001.1594@p34.internal.lan>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 05:19:11PM -0400, Justin Piszcz wrote:
> For the root filesystem, on / type xfs (rw,noatime)
> For larger partitions (per the cryptoloop doc) the partition itself is  
> setup via cryptoloop and then XFS ontop of that.  Nothing special.

Just to make sure we have all data here - you see the problem only
with loop devices backed by XFS, only with loop devices backed by
raw partitions or with both?

>> Any way to trgiger it with just loop but not crypto, etc.
> Unfortunately not that I am aware of..  Would trying the kernel with the  
> patch removed and mounted with -o nobarrier help to show us anything, or?

Actually, yes - seeing what happens if you run plain 2.6.30 or 2.6.31-rc
without the backout patch, but with -o nobarrier would be very
interesting.
