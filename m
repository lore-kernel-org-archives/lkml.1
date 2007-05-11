Return-Path: <linux-kernel-owner+w=401wt.eu-S933591AbXEKW1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbXEKW1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 18:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbXEKW1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 18:27:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43744 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbXEKW1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 18:27:05 -0400
Message-ID: <4644EDB6.5060108@garzik.org>
Date: Fri, 11 May 2007 18:27:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: NFS spews warnings on x86-64
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Current git, on Fedora 6/x86-64:

fs/nfs/read.c: In function ‘nfs_return_empty_page’:
fs/nfs/read.c:82: warning: ‘memclear_highpage_flush’ is deprecated 
(declared at include/linux/highmem.h:115)
fs/nfs/read.c: In function ‘nfs_readpage_truncate_uninitialised_page’:
fs/nfs/read.c:106: warning: ‘memclear_highpage_flush’ is deprecated 
(declared at include/linux/highmem.h:115)
fs/nfs/read.c:109: warning: ‘memclear_highpage_flush’ is deprecated 
(declared at include/linux/highmem.h:115)
fs/nfs/read.c: In function ‘nfs_readpage_async’:
fs/nfs/read.c:133: warning: ‘memclear_highpage_flush’ is deprecated 
(declared at include/linux/highmem.h:115)
fs/nfs/read.c: In function ‘readpage_async_filler’:
fs/nfs/read.c:535: warning: ‘memclear_highpage_flush’ is deprecated 
(declared at include/linux/highmem.h:115)
fs/nfs/write.c: In function ‘nfs_mark_uptodate’:
fs/nfs/write.c:171: warning: ‘memclear_highpage_flush’ is deprecated 
(declared at include/linux/highmem.h:115)
fs/nfs/nfs4xdr.c: In function ‘decode_close’:
fs/nfs/nfs4xdr.c:2900: warning: format ‘%u’ expects type ‘unsigned int’, 
but argument 4 has type ‘long unsigned int’
fs/nfs/nfs4xdr.c: In function ‘decode_lock’:
fs/nfs/nfs4xdr.c:3189: warning: format ‘%u’ expects type ‘unsigned int’, 
but argument 4 has type ‘long unsigned int’
fs/nfs/nfs4xdr.c: In function ‘decode_locku’:
fs/nfs/nfs4xdr.c:3212: warning: format ‘%u’ expects type ‘unsigned int’, 
but argument 4 has type ‘long unsigned int’
fs/nfs/nfs4xdr.c: In function ‘decode_open’:
fs/nfs/nfs4xdr.c:3278: warning: format ‘%u’ expects type ‘unsigned int’, 
but argument 4 has type ‘long unsigned int’
fs/nfs/nfs4xdr.c: In function ‘decode_open_confirm’:
fs/nfs/nfs4xdr.c:3305: warning: format ‘%u’ expects type ‘unsigned int’, 
but argument 4 has type ‘long unsigned int’
fs/nfs/nfs4xdr.c: In function ‘decode_open_downgrade’:
fs/nfs/nfs4xdr.c:3318: warning: format ‘%u’ expects type ‘unsigned int’, 
but argument 4 has type ‘long unsigned int’
fs/nfs/nfs4xdr.c: In function ‘decode_setclientid’:
fs/nfs/nfs4xdr.c:3593: warning: format ‘%u’ expects type ‘unsigned int’, 
but argument 4 has type ‘long unsigned int’
