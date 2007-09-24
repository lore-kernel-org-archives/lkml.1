Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbXIXNLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbXIXNLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbXIXNKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:10:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50599 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbXIXNKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:10:53 -0400
Date: Mon, 24 Sep 2007 14:10:48 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: matthew@wil.cx, hch@infradead.org, trond.myklebust@fys.uio.no,
       adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/2] VFS: new fgetattr() file operation
Message-ID: <20070924131047.GA19017@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, matthew@wil.cx,
	trond.myklebust@fys.uio.no, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu> <20070924123640.GA17409@infradead.org> <E1IZnM8-0003sG-00@dorka.pomaz.szeredi.hu> <20070924125948.GM10625@parisc-linux.org> <E1IZndW-0003uI-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IZndW-0003uI-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 03:06:06PM +0200, Miklos Szeredi wrote:
> If a network filesystem protocol can't handle operations (be it data
> or metadata) on an unlinked file, we must do sillirenaming, so that
> the file is not actually unlinked.

Or not support such a broken protocol at all.

