Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbYELD5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbYELD5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 23:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYELD51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 23:57:27 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49341 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYELD50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 23:57:26 -0400
Date: Sun, 11 May 2008 23:49:35 -0400
Message-Id: <200805120349.m4C3nZdI018467@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: bharata@linux.vnet.ibm.com
Cc: David Newall <davidn@davidnewall.com>, Ulrich Drepper <drepper@redhat.com>,
       bsn.0007@gmail.com, libc-alpha@sourceware.org,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Mingming Cao <cmm@us.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 1/2] Union Mount: glibc readdir support 
In-reply-to: Your message of "Mon, 12 May 2008 09:13:41 +0530."
             <20080512034341.GA10541@in.ibm.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080512034341.GA10541@in.ibm.com>, Bharata B Rao writes:

> Answering my question to Erez that I raised in another thread, I see
> that Unionfs doesn't set the export_operations in it's superblock and
> hence I believe unions created by Unionfs aren't NFS-exportable as of
> know. Erez, correct me if I got it wrong.

Yes, the unionfs in -mm isn't nfs exportable safely, b/c it doesn't have
persistent inode numbers.  Our unionfs-odf version has persistent inode
numbers and is exportable (see http://unionfs.filesystems.org/).

> Regards,
> Bharata.

Erez.
