Return-Path: <linux-kernel-owner+w=401wt.eu-S1763193AbXKMTon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763193AbXKMTon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761574AbXKMTod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:44:33 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52914 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763018AbXKMTob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:44:31 -0500
Date: Tue, 13 Nov 2007 11:43:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, steved@redhat.com,
       trond.myklebust@fys.uio.no,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nfs functions undefined [Was: mm snapshot
 broken-out-2007-11-13-04-14.tar.gz uploaded]
Message-Id: <20071113114332.808bdc4a.akpm@linux-foundation.org>
In-Reply-To: <20071113093442.bc2554c6.randy.dunlap@oracle.com>
References: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
	<47399DA8.2060501@gmail.com>
	<20071113093442.bc2554c6.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 09:34:42 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Tue, 13 Nov 2007 13:50:48 +0100 Jiri Slaby wrote:
> 
> > On 11/13/2007 01:15 PM, akpm@linux-foundation.org wrote:
> > > The mm snapshot broken-out-2007-11-13-04-14.tar.gz has been uploaded to
> > 
> > ERROR: "nfs_put_super" [fs/nfs/nfs.ko] undefined!
> > ERROR: "nfs_sb_deactive" [fs/nfs/nfs.ko] undefined!
> > make[2]: *** [__modpost] Error 1
> > make[1]: *** [modules] Error 2

Argh, that's me trying to fix Steve's fix to Steve's fix.

> > config:
> > http://www.fi.muni.cz/~xslaby/sklad/config_64
> 
> 
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> nfs_put_super() and nfs_sb_deactive() should not be inside an
> ifdef CONFIG_NFS_V4 block.

<queues nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix-fix.patch>

Thanks.
