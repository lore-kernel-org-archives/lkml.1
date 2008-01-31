Return-Path: <linux-kernel-owner+w=401wt.eu-S934646AbYAaXaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646AbYAaXaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 18:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbYAaX36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 18:29:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbYAaX34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:29:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8DB49AEC-5DA8-4AC3-A660-689E6BC80D2E@oracle.com>
References: <8DB49AEC-5DA8-4AC3-A660-689E6BC80D2E@oracle.com> <479901A8.3000706@oracle.com> <20080123172038.11107.86025.stgit@warthog.procyon.org.uk> <20080123172246.11107.62216.stgit@warthog.procyon.org.uk> <18686.1201663501@redhat.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 24/27] NFS: Use local caching [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 31 Jan 2008 23:29:17 +0000
Message-ID: <28512.1201822157@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Lever <chuck.lever@oracle.com> wrote:

> >>> +struct nfs_fh_auxdata {
> >>> +	struct timespec	i_mtime;
> >>> +	struct timespec	i_ctime;
> >>> +	loff_t		i_size;
> >>> +};
> >>
> >> It might be useful to explain here why you need to supplement the
> >> mtime, ctime, and size fields that already exist in an NFS inode.
> >
> > Supplement?  I don't understand.
> 
> Why is it necessary to add additional mtime, ctime and size fields for NFS
> inodes?  Similar metadata is already stored in nfsi.

Yes, but this is the data that's stored in the cache on disk, not what's
stored in the NFS inode struct in RAM.

I'll add some more comments to the code to make this clearer.

David
