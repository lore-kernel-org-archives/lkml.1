Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbZHZSCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbZHZSCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZHZSCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:02:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55966 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbZHZSCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:02:33 -0400
Date: Wed, 26 Aug 2009 14:02:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Nikanth Karthikesan <knikanth@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Kernel 2.6.30.4 loop(..?) regression (& with/2.6.31-rc6)
Message-ID: <20090826180234.GC14019@infradead.org>
References: <alpine.DEB.2.00.0908220624440.30321@p34.internal.lan> <20090822142550.GA10003@infradead.org> <alpine.DEB.2.00.0908221044420.30321@p34.internal.lan> <20090822201558.GA17955@infradead.org> <alpine.DEB.2.00.0908221645440.20848@p34.internal.lan> <20090822205502.GA18904@infradead.org> <alpine.DEB.2.00.0908221659030.23463@p34.internal.lan> <20090823224504.GA19942@infradead.org> <alpine.DEB.2.00.0908240704130.9427@p34.internal.lan> <alpine.DEB.2.00.0908260949550.9396@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908260949550.9396@p34.internal.lan>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 09:50:27AM -0400, Justin Piszcz wrote:
> So far the uptime is 2 days, if it does not recur in the next 24-48 
> hours, do you recommend I follow up with the linux-crypto folks about 
> this?  It appears this could be the cause (no issues, as of yet).

At this point it doesn't look crypto related anymore, but like some
bad interaction between layers once we add those fsync in the loop code.

What filesystem does you loop image reside on?   Anything else special?
Any way to trgiger it with just loop but not crypto, etc.

