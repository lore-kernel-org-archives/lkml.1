Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbYDMJUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbYDMJUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 05:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbYDMJUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 05:20:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697AbYDMJUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:20:32 -0400
Date: Sun, 13 Apr 2008 05:20:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bob Copeland <me@bobcopeland.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 3/7] omfs: add directory routines
Message-ID: <20080413092023.GA19626@infradead.org>
References: <1208041121-26787-4-git-send-email-me@bobcopeland.com> <20080413101144.4d496e9d@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413101144.4d496e9d@core>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 10:11:44AM +0100, Alan Cox wrote:
> 
> > +static int omfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
> > +{
> > +	struct inode *dir = filp->f_dentry->d_inode;
> > +	struct buffer_head *bh = NULL;
> 
> > +	if (filp->f_pos >> 32)
> > +		goto success;
> 
> f_pos may be 32bit in which case >> 32 does not have defined behaviour in
> C.

f_pos is always 64bit since 2.3.x

