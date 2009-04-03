Return-Path: <linux-kernel-owner+w=401wt.eu-S1762707AbZDCJwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707AbZDCJwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 05:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbZDCJwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 05:52:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47353 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbZDCJwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 05:52:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090403094138.9510.80681.stgit@warthog.procyon.org.uk>
References: <20090403094138.9510.80681.stgit@warthog.procyon.org.uk>
To: nickpiggin@yahoo.com.au, hch@infradead.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] CacheFiles: Use the ->write() file op rather than a special kernel aop
Date: Fri, 03 Apr 2009 10:51:56 +0100
Message-ID: <9759.1238752316@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> This reverts the patch:
> 
> 	CacheFiles: Add a hook to write a single page of data to an inode
> 
> 	Add an address space operation to write one single page of data to an
> 	inode at a page-aligned location (thus permitting the implementation to
> 	be highly optimised).  The data source is a single page.
> 
> 	This is used by CacheFiles to store the contents of netfs pages into
> 	their backing file pages.
> 
> 	Supply a generic implementation for this that uses the write_begin()
> 	and write_end() address_space operations to bind a copy directly into
> 	the page cache.
> 
> 	Hook the Ext2 and Ext3 operations to the generic implementation.

Actually, it doesn't.  I split that out into the next patch, but I forgot to
edit the patch description.

David
