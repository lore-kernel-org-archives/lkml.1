Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZALIDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZALIDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 03:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZALID2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 03:03:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZALID1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 03:03:27 -0500
Date: Mon, 12 Jan 2009 03:03:25 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Qinghuang Feng <qhfeng.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, linux-nfs@vger.kernel.org
Subject: Re: [PATCH] NFSD: cleanup for nfs3proc.c
Message-ID: <20090112080325.GA418@infradead.org>
References: <496a44f7.05636e0a.69b8.6278@mx.google.com> <20090112011231.GA31971@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112011231.GA31971@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 08:12:31PM -0500, J. Bruce Fields wrote:
> On Mon, Jan 12, 2009 at 03:13:53AM +0800, Qinghuang Feng wrote:
> > MSDOS_SUPER_MAGIC is defined in <linux/magic.h>,
> > so use MSDOS_SUPER_MAGIC directly.
> 
> Thanks.  But does anyone know if there's any better way to figure out
> whether a filesystem supports links and symlinks than by checking
> s_magic == MSDOS_SUPER_MAGIC??

Or case insenstivit or..

If we had a working pathconf syscall and inode operation that'd be
easy..

