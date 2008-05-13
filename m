Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYEMI2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYEMI2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbYEMI2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:28:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45875 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbYEMI2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:28:13 -0400
To: ezk@cs.sunysb.edu
CC: hch@infradead.org, miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <200805092002.m49K2R5p014283@agora.fsl.cs.sunysb.edu> (message
	from Erez Zadok on Fri, 9 May 2008 16:02:27 -0400)
Subject: Re: [patch 6/9] fuse: add export operations
References: <200805092002.m49K2R5p014283@agora.fsl.cs.sunysb.edu>
Message-Id: <E1JvprY-0000S0-5v@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 13 May 2008 10:27:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Only finding in-memory inodes for nfs export is quite dangerous.  I
> > think it would be a much better idea to support whatever upcalls are
> > needed to find the object if it's not in memory.  Without that the nfs
> > exporting support is hardly useable.
> 
> In the ODF version of unionfs, we store the inode numbers persistently in a
> small /odf partition, exactly for that reason.

What do inode numbers index on that partition?  A path?  How do you
garbage collect unused inode numbers?

>  It'd be wonderful if there
> was kernel support for persistent inode numbers that could be used by
> various virtual filesystems.

Well, fuse for one doesn't need it because it's typically a function
that is best pushed to userspace.

Miklos
