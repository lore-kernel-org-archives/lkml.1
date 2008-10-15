Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbYJOThe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbYJOThe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYJOTh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:37:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35767 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbYJOThZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:37:25 -0400
Date: Wed, 15 Oct 2008 15:37:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, bnaujok@sgi.com
Subject: Re: [PATCH 6/6] vfs: add LOOKUP_RENAME_NEW intent
Message-ID: <20081015193716.GA22707@infradead.org>
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp> <e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp> <7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp> <524881153e848f5f6f3426623.ps@mail.parknet.co.jp> <f29a09483e848f5f6f3526623.ps@mail.parknet.co.jp> <a9ddfd693e848f5f6f3626623.ps@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9ddfd693e848f5f6f3626623.ps@mail.parknet.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 10:58:11PM +0900, OGAWA Hirofumi wrote:
> 
> This adds LOOKUP_RENAME_NEW intent for lookup of rename destination.
> 
> LOOKUP_RENAME_NEW is going to be used like LOOKUP_CREATE. But since
> the destination of rename() can be existing directory entry, so it has a
> difference. Although that difference doesn't matter in my usage, this
> tells it to user of this intent.

Is this for handling CI rename properly?  Barry was looking into this,
but i told him to hold off for a while - the lookup code is changing
quite a bit because Al is trying to sort out the lookup intent mess and
we hopefully will stop passing the nameidata to ->lookup soon.

Also I think LOOKUP_RENAME_TARGET might be a little more descriptive
than LOOKUP_RENAME_NEW.

