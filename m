Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbXIXN1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbXIXN1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXIXN1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:27:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43520 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbXIXN1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:27:30 -0400
Date: Mon, 24 Sep 2007 14:27:25 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, matthew@wil.cx, trond.myklebust@fys.uio.no,
       adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/2] VFS: new fgetattr() file operation
Message-ID: <20070924132725.GA20116@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, matthew@wil.cx,
	trond.myklebust@fys.uio.no, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu> <20070924123640.GA17409@infradead.org> <E1IZnM8-0003sG-00@dorka.pomaz.szeredi.hu> <20070924125948.GM10625@parisc-linux.org> <E1IZndW-0003uI-00@dorka.pomaz.szeredi.hu> <20070924131047.GA19017@infradead.org> <E1IZnpC-0003vk-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IZnpC-0003vk-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 03:18:10PM +0200, Miklos Szeredi wrote:
> > Or not support such a broken protocol at all.
> 
> Wonder what people would say if we removed support for NFSv[23].
> 
> Just because a protocol does not support "perfect" UNIX semantics, it
> doesn't mean it's broken.  By that standard almost all network
> filesystem protocols are severely broken.

Well, they are broken by these and other standards.  At least nfs and
cifs maintainers do the workarounds for this brokeness where they belong.
