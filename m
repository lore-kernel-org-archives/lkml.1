Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbXJ3Ru0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbXJ3Ru0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbXJ3RuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:50:12 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38885 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbXJ3RuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:50:10 -0400
Date: Tue, 30 Oct 2007 13:49:48 -0400
Message-Id: <200710301749.l9UHnmRF000734@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/4] VFS: factor out three helpers for FIBMAP/FIONBIO/FIOASYNC file ioctls 
In-reply-to: Your message of "Tue, 30 Oct 2007 09:59:32 -0000."
             <20071030095932.GD22413@infradead.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, what's the origin of this oddity in fs/ioctl.c:

#ifdef __sparc__
	/* SunOS compatibility item. */
	if (O_NONBLOCK != O_NDELAY)
		flag |= O_NDELAY;
#endif

It seems rather odd to have architecture-specific code in the VFS, no?

Erez.
