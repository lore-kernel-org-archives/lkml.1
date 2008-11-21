Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYKUK11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYKUK11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYKUK1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:27:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37705 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYKUK1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:27:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081121001237.a26cbe8f.akpm@linux-foundation.org>
References: <20081121001237.a26cbe8f.akpm@linux-foundation.org> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144205.10667.290.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/45] FS-Cache: Release page->private after failed readahead [ver #41]
Date: Fri, 21 Nov 2008 10:27:09 +0000
Message-ID: <18660.1227263229@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > +		if (TestSetPageLocked(page))
> 
> This got obsoleted by trylock_page().
> 
> I don't remember why, actually.

trylock_page() throws memory barriers in there on, say, PowerPC.  That's
probably necessary.

David
