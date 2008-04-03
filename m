Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbYDCWdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbYDCWdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 18:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbYDCWc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 18:32:56 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60018 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbYDCWc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 18:32:56 -0400
Date: Thu, 3 Apr 2008 18:32:39 -0400
Message-Id: <200804032232.m33MWdZW026800@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod() 
In-reply-to: Your message of "Thu, 03 Apr 2008 09:32:59 +0200."
             <E1JhJwR-0008Vv-2x@pomaz-ex.szeredi.hu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <E1JhJwR-0008Vv-2x@pomaz-ex.szeredi.hu>, Miklos Szeredi writes:
[...]
> If it wants to handle that case nicely, it can monitor /proc/mounts
> and reflect it in it's superblock flags.  And it can take a write-ref
> on the underlying fs if it has outstanding dirtyness.  But we should
> not _rely_ on ecryptfs to ensure that it's never writing to a
> read-only mount.

I'm all for reducing the need for stackable f/s such as ecryptfs from having
to remember to manage the write counts.  A stackable filesystem has to
emulate some parts of the VFS when it calls into a lower f/s: in that case,
having useful VFS helpers that do as much of the work as possible, saves a
lot of hassle.

> Miklos

Cheers,
Erez.
