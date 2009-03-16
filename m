Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbZCPIep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbZCPIep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbZCPIef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:34:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbZCPIee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:34:34 -0400
Date: Mon, 16 Mar 2009 04:34:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Laurent GUERBY <laurent@guerby.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [2.6.29-rc5][BUG] swapon on vfat file gets stuck on inode lock
Message-ID: <20090316083427.GA3685@infradead.org>
References: <1236779832.11347.2082.camel@localhost> <alpine.LFD.2.00.0903110837590.32478@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903110837590.32478@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 08:53:14AM -0700, Linus Torvalds wrote:
> I dunno. No other filesystem has _any_ locking in their bmap that I can 
> see, so I strongly suspect that fat doesn't need it either. 

XFS has proper locking using it's own locks.

Then again Peter had patchset somewhere to implement proper aops for
swap instead of abusing -bmap to implement swap over NFS, which should
be able to fix this for fat, too.
