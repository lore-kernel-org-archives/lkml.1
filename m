Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbXIXM77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbXIXM77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXIXM7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:59:51 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45326 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbXIXM7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:59:50 -0400
Date: Mon, 24 Sep 2007 06:59:48 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, trond.myklebust@fys.uio.no, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/2] VFS: new fgetattr() file operation
Message-ID: <20070924125948.GM10625@parisc-linux.org>
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu> <20070924123640.GA17409@infradead.org> <E1IZnM8-0003sG-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IZnM8-0003sG-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 02:48:08PM +0200, Miklos Szeredi wrote:
> > and if that means adding silly rename support so be it.
> 
> That's what is done currently.
> 
> But it's has various dawbacks, like rmdir doesn't work if there are
> open files within an otherwise empty directory.
> 
> I'd happily accept suggestions on how to deal with this differenty.

Only sillyrename files with nlink > 1?  I don't see how attributes can
change anything for a deleted file.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
