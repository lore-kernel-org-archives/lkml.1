Return-Path: <linux-kernel-owner+w=401wt.eu-S937762AbXHHRZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937762AbXHHRZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964927AbXHHRUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:20:24 -0400
Received: from lazybastard.de ([212.112.238.170]:43856 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887AbXHHRUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:20:21 -0400
Date: Wed, 8 Aug 2007 19:15:54 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, akpm@osdl.org,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [Patch 05/18] fs/logfs/dir.c
Message-ID: <20070808171554.GV15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org> <20070808161626.GG15319@lazybastard.org> <1186592854.19606.49.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1186592854.19606.49.camel@sauron>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 August 2007 20:07:34 +0300, Artem Bityutskiy wrote:
> On Wed, 2007-08-08 at 18:16 +0200, Jörn Engel wrote:
> > +static inline void logfs_inc_count(struct inode *inode)
> > +{
> > +	inode->i_nlink++;
> > +	mark_inode_dirty_sync(inode);
> > +}
> > +
> > +static inline void logfs_dec_count(struct inode *inode)
> > +{
> > +	inode->i_nlink--;
> > +	mark_inode_dirty_sync(inode);
> > +}
> include/linux/fs.h: inode_inc_link_count() inode_dec_link_count() do
> this. Although not sure they exist in the old kernel your patches are
> against.

Almost, they call mark_inode_dirty() instead of mark_inode_dirty_sync().
I wonder if that's necessary.

Jörn

-- 
Measure. Don't tune for speed until you've measured, and even then
don't unless one part of the code overwhelms the rest.
-- Rob Pike
