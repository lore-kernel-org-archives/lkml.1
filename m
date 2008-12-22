Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYLVIvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYLVIvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 03:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYLVIuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 03:50:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48870 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbYLVIuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 03:50:51 -0500
Date: Mon, 22 Dec 2008 03:50:47 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
Subject: Re: Intel X25-E running Linux using XFS
Message-ID: <20081222085047.GA24795@infradead.org>
References: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan> <20081212185803.GE11974@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212185803.GE11974@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 07:58:03PM +0100, Pavel Machek wrote:
> Actually I'd like to know... how does it behave during powerfails
> while it is being written to?

I've done various powerfail tests with and X25-M and as expect it
behaves perfectly fine as long as you either disable the write cache
or use barriers.  The default ext3 setup without barriers corrupts
the filesystem left, right and center, but that's the same as other
recent disk drives with large caches.

