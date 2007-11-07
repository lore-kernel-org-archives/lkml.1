Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbXKGGp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbXKGGp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbXKGGpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:45:11 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45858 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbXKGGpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:45:09 -0500
Date: Wed, 7 Nov 2007 01:44:50 -0500
Message-Id: <200711070644.lA76iodZ005491@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, ezk@cs.sunysb.edu, unionfs@filesystems.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IGET: Stop UnionFS from using iget() and read_inode() 
In-reply-to: Your message of "Tue, 06 Nov 2007 14:52:34 GMT."
             <20071106145234.4807.69325.stgit@warthog.procyon.org.uk> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071106145234.4807.69325.stgit@warthog.procyon.org.uk>, David Howells writes:
> From: David Howells <dhowells@redhat.com>
> 
> Stop the UnionFS filesystem from using iget() and read_inode().  Replace
> unionfs_read_inode() with unionfs_iget(), and call that instead of iget().
> unionfs_iget() then uses iget_locked() directly and returns a proper error code
> instead of an inode in the event of an error.
> 
> unionfs_fill_super() returns any error incurred when getting the root inode
> instead of EINVAL.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
[...]

Thanks.  I tested this code and it passed all my tests.  I'll shortly submit
a slightly revised patch which applies cleanly against the unionfs code in
-mm.

Cheers,
Erez.
