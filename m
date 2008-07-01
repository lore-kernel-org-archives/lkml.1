Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYGAMT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYGAMT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYGAMTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:19:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39127 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521AbYGAMTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:19:05 -0400
Date: Tue, 1 Jul 2008 08:18:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] fat: Fix VFAT_IOCTL_READDIR_xxx and cleanup for
	userland
Message-ID: <20080701121827.GA25580@infradead.org>
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp> <129170883e848699cff211608.ps@mail.parknet.co.jp> <20080701074033.GB30362@infradead.org> <20080701112248.GA17558@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701112248.GA17558@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 02:22:48PM +0300, Adrian Bunk wrote:
> > Given that the current version can't actually work without defininig
> > it's own dirent and thus ioctl number symbolic name I wonder if these
> > ioctls are used at all?  They must have been completely untested for
> > a while, and I suspect we'd be better off just removing them.
> 
> I had the same thought, but when checking this I noticed that at least 
> wine works around this problem:

Ok, I'll withdraw my objection in that case.

