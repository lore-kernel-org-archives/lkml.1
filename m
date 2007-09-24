Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbXIXNh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbXIXNh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbXIXNhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:37:13 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41603 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754693AbXIXNhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:37:11 -0400
Date: Mon, 24 Sep 2007 14:42:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, miklos@szeredi.hu, trond.myklebust@fys.uio.no,
       adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/2] VFS: new fgetattr() file operation
Message-ID: <20070924144229.03c4aec2@the-village.bc.nu>
In-Reply-To: <E1IZnM8-0003sG-00@dorka.pomaz.szeredi.hu>
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu>
	<20070924123640.GA17409@infradead.org>
	<E1IZnM8-0003sG-00@dorka.pomaz.szeredi.hu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But it's has various dawbacks, like rmdir doesn't work if there are
> open files within an otherwise empty directory.
> 
> I'd happily accept suggestions on how to deal with this differenty.

NFS has that problem because it really has to sillyrename into the same
directory. I don't see that ssh/sftp needs to do that. Instead it can
sillyrename anywhere in the filesystem.

Alan
