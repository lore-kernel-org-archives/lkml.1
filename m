Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbXJ3PWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbXJ3PWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbXJ3PWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:22:44 -0400
Received: from xenotime.net ([66.160.160.81]:50246 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752589AbXJ3PWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:22:42 -0400
Date: Tue, 30 Oct 2007 08:22:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/4] VFS: swap do_ioctl and vfs_ioctl names
Message-Id: <20071030082240.1ad71e6c.rdunlap@xenotime.net>
In-Reply-To: <20071030095653.GC22413@infradead.org>
References: <11936184581182-git-send-email-ezk@cs.sunysb.edu>
	<11936184592699-git-send-email-ezk@cs.sunysb.edu>
	<20071030095653.GC22413@infradead.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 09:56:53 +0000 Christoph Hellwig wrote:

> On Sun, Oct 28, 2007 at 08:40:56PM -0400, Erez Zadok wrote:
> > +/**
> > + * vfs_ioctl - call filesystem specific ioctl methods
> > + *
> > + * @filp: [in]     open file to invoke ioctl method on
> > + * @cmd:  [in]     ioctl command to execute
> > + * @arg:  [in/out] command-specific argument for ioctl
> 
> I've never seen these in/out annotations and doubt they're valid in
> kerneldoc.  Randy?

They are just treated as part of the parameter explanation text.
I don't see any problem with them.

> > + * Invokes filesystem specific ->unlock_ioctl, if one exists; otherwise
> 
> unlocked_ioctl


---
~Randy
