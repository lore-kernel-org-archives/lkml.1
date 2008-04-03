Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbYDCAzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbYDCAzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbYDCAzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:55:38 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:41436 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbYDCAzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:55:38 -0400
Date: Wed, 2 Apr 2008 20:47:06 -0400
Message-Id: <200804030047.m330l6Pf032755@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       akpm@linux-foundation.org, dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod() 
In-reply-to: Your message of "Wed, 02 Apr 2008 20:42:09 EDT."
             <1207183329.20254.49.camel@heimdal.trondhjem.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1207183329.20254.49.camel@heimdal.trondhjem.org>, Trond Myklebust writes:
> 
> On Thu, 2008-04-03 at 00:47 +0100, Al Viro wrote:
[...]
> >  Again, what for?
> 
> It allows you to get rid of the vfsmount 'argument' when opening a file,
> which again lowers the barrier for stacking filesystems.
> 
> As far as the filesystems themselves are concerned, the effect is to
> enforce your assertion that file operations should not depend on the
> namespace.

I'd be delighted the day I won't have to deal with vfsmounts AT ALL in
any stacked f/s.

Erez.
