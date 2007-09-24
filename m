Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbXIXNTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbXIXNTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759011AbXIXNSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:18:50 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:35646 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548AbXIXNSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:18:49 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, matthew@wil.cx, hch@infradead.org,
       trond.myklebust@fys.uio.no, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20070924131047.GA19017@infradead.org> (message from Christoph
	Hellwig on Mon, 24 Sep 2007 14:10:48 +0100)
Subject: Re: [patch 1/2] VFS: new fgetattr() file operation
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu> <20070924123640.GA17409@infradead.org> <E1IZnM8-0003sG-00@dorka.pomaz.szeredi.hu> <20070924125948.GM10625@parisc-linux.org> <E1IZndW-0003uI-00@dorka.pomaz.szeredi.hu> <20070924131047.GA19017@infradead.org>
Message-Id: <E1IZnpC-0003vk-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Sep 2007 15:18:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > If a network filesystem protocol can't handle operations (be it data
> > or metadata) on an unlinked file, we must do sillirenaming, so that
> > the file is not actually unlinked.
> 
> Or not support such a broken protocol at all.

Wonder what people would say if we removed support for NFSv[23].

Just because a protocol does not support "perfect" UNIX semantics, it
doesn't mean it's broken.  By that standard almost all network
filesystem protocols are severely broken.

Miklos
