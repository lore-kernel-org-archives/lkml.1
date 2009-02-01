Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZBAQmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZBAQmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZBAQlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:41:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42423 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbZBAQlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:41:49 -0500
Date: Sun, 1 Feb 2009 11:41:30 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Arnd Bergmann <arnd@arndb.de>, mfasheh@suse.com, joel.becker@oracle.com,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk,
       Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
       ocfs2-devel@oss.oracle.com
Subject: Re: [xfs-masters] [PATCH] fs: Add new pre-allocation ioctls to vfs
	for compatibility with legacy xfs ioctls
Message-ID: <20090201164130.GA32276@infradead.org>
References: <20090130171423.f99c88d0.akpm@linux-foundation.org> <200901310248.42820.arnd@arndb.de> <49856FE6.8020601@panasas.com> <Pine.LNX.4.64.0902011104320.20875@anakin> <49857BEB.30404@panasas.com> <Pine.LNX.4.64.0902011151180.20875@anakin> <4985966D.8040402@panasas.com> <4985C1B0.8060905@sandeen.net> <4985CCFA.4070008@panasas.com> <4985CF66.6090409@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4985CF66.6090409@sandeen.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The structures have been defined exactly like that in XFS (and ocfs2)
before, and there are similar cases in other ioctls handlers.

If anyone feels like changing this in some way feel free to wade through
the endless discussions about the pros and cons for it, but I think
doing it in context of this patch is not helpful.
