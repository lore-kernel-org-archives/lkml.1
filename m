Return-Path: <linux-kernel-owner+w=401wt.eu-S1757826AbYEFEWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbYEFEWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYEFEVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:21:40 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39698 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbYEFEV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:21:29 -0400
Date: Tue, 6 May 2008 09:51:17 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: bsn.0007@gmail.com, libc-alpha@sourceware.org,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Mingming Cao <cmm@us.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 1/2] Union Mount: glibc readdir support
Message-ID: <20080506042117.GA29298@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20080429133201.GA9938@localhost.localdomain> <20080429133346.GB9938@localhost.localdomain> <48195E69.3030701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48195E69.3030701@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 11:08:41PM -0700, Ulrich Drepper wrote:
> 
> Before anything further is discussed I need to know how you expect to
> handle NFS?  I don't see how, with a userlevel readdir implementation,
> you can support NFS.

At the client side, I don't see a problem with unioning NFS with other
FS. Kernel would still return all dirents of the union including those
from NFS and glibc readdir would be able to handle them appropriately.
Or am I missing something ?

At the server side, I can't see how NFS server could export a union.
I don't see how this could be sanely done with Union Mount. Erez, how
does Unionfs handle this ?

Is dis-allowing NFS-exporting of unions an option ?

Regards,
Bharata.
