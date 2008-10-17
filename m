Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYJQUh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYJQUh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYJQUhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:37:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56322 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYJQUhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:37:11 -0400
Date: Fri, 17 Oct 2008 16:37:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context at
	kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Message-ID: <20081017203710.GA27187@infradead.org>
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com> <20081017164116.GA17375@infradead.org> <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com> <20081017165738.GA20818@infradead.org> <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just ran the xfs testsuite over linux-next on qemu (i386), and I can't
find anything at all.  Really strange.  Let's see if this still there
with mondays linux-next, and if yes can you just try the xfs patch from
the splitout linux-next patches and see if that alone causes it?

In fact that might be useful for todays linux-next, too.
