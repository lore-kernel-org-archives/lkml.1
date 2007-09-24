Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbXIXNln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbXIXNln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757131AbXIXNlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:41:35 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:47237 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809AbXIXNle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:41:34 -0400
To: alan@lxorguk.ukuu.org.uk
CC: miklos@szeredi.hu, hch@infradead.org, miklos@szeredi.hu,
       trond.myklebust@fys.uio.no, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20070924144229.03c4aec2@the-village.bc.nu> (message from Alan
	Cox on Mon, 24 Sep 2007 14:42:29 +0100)
Subject: Re: [patch 1/2] VFS: new fgetattr() file operation
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu>
	<20070924123640.GA17409@infradead.org>
	<E1IZnM8-0003sG-00@dorka.pomaz.szeredi.hu> <20070924144229.03c4aec2@the-village.bc.nu>
Message-Id: <E1IZoAb-0003xu-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Sep 2007 15:40:17 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > But it's has various dawbacks, like rmdir doesn't work if there are
> > open files within an otherwise empty directory.
> > 
> > I'd happily accept suggestions on how to deal with this differenty.
> 
> NFS has that problem because it really has to sillyrename into the same
> directory. I don't see that ssh/sftp needs to do that. Instead it can
> sillyrename anywhere in the filesystem.

I don't think it can.  How can we find in a reliable way another
directory, which is writable by the user?

Miklos
