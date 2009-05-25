Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbZEYRLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbZEYRLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 13:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZEYRLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 13:11:00 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:44127 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbZEYRK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 13:10:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NnpYAc6RqJv77mlaI5OgYnZwXdLhndUuQWvSVmHlgkYdTd+1wBNKcpbKGz0RB3x54z
         sydbmnmOoEwg80QY1NplmxFDPSteULZmPtKxtKNw8ZJd3QVoti9DEG88LCDkhGN8WL2F
         E1oC2rbQFtGs1uENzI1enoX+Y8QYOUJDEHZQQ=
Date: Mon, 25 May 2009 19:10:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the vfs tree with the  tree
Message-ID: <20090525171055.GA7879@nowhere>
References: <20090522112326.9eafa340.sfr@canb.auug.org.au> <20090524220336.GF6471@nowhere> <20090524220747.GA12433@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090524220747.GA12433@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 12:07:47AM +0200, Christoph Hellwig wrote:
> On Mon, May 25, 2009 at 12:03:38AM +0200, Frederic Weisbecker wrote:
> > > + 	if (s->s_dirt)
> > > + 		reiserfs_write_super(s);
> > 
> > 
> > 
> > But this part seems to solve another conflict, right?
> > I'm not sure about it.
> 
> Yes, different one.  Previously the VFS called ->write_super just before
> ->put_super.  Now any left over writeback needs to be dealt with by
> the filesystem.  For now I have added a call to the write_super method
> to all filesystems, but most likely this can be removed later after
> an audit by someone who knows the filesystem.
>

Ok. Thanks for the clarification. So Stephen's fix seems to be
correct.

Thanks.

