Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYJOToq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYJOToq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYJOToh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:44:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYJOToh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:44:37 -0400
Date: Wed, 15 Oct 2008 15:44:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] vfs: remove LOOKUP_PARENT from non LOOKUP_PARENT
	lookup
Message-ID: <20081015194434.GC24892@infradead.org>
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp> <e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp> <7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp> <524881153e848f5f6f3426623.ps@mail.parknet.co.jp> <f29a09483e848f5f6f3526623.ps@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f29a09483e848f5f6f3526623.ps@mail.parknet.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 10:58:11PM +0900, OGAWA Hirofumi wrote:
> 
> lookup_hash() with LOOKUP_PARENT is bogus. And this prepares to add
> new intent on those path.
> 
> The user of LOOKUP_PARENT intent is nfs only, and it checks whether
> nd->flags has LOOKUP_CREATE or LOOKUP_OPEN, so the result is same.

Makes sense to me, but in this area you really need to work against
Al's vfs.git tree as there's quite some work going on.

