Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYKUMpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYKUMpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 07:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYKUMo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 07:44:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51302 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755779AbYKUMoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 07:44:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081121002317.69e4fd11.akpm@linux-foundation.org>
References: <20081121002317.69e4fd11.akpm@linux-foundation.org> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144343.10667.530.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 24/45] CacheFiles: Add a hook to write a single page of data to an inode [ver #41]
Date: Fri, 21 Nov 2008 12:43:41 +0000
Message-ID: <3843.1227271421@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Sigh.  I don't normally comment on busted comment layout, but Ingo does
> so I'm allowed to ;) See recent discussion around the kmemleak patches.

Sigh.  Three points for you to consider:

 (1) The prevailing comment style in struct address_space_operations does not
     have comment delimiters on their own lines.  This has the advantage that
     it doesn't unnecessarily waste two lines per comment.  I will advocate
     that style for banner comments for top-level constructs, but for internal
     comments it's generally a poor compromise.

     The following comment on braces applies also to comments:

	Also, note that this brace-placement also minimizes the number of empty
	(or almost empty) lines, without any loss of readability.  Thus, as the
	supply of new-lines on your screen is not a renewable resource (think
	25-line terminal screens here), you have more empty lines to put
	comments on.

 (2) Randy Dunlap should be beaten for his contribution to CodingStyle.  Next
     time I have the opportunity, I'll do just that, and this time I'll see
     about using one of my own racquets rather than one of his:-P

 (3) It's so much easier to write style guides than to properly document one's
     code.

</rant>

> > +/**
> > + * generic_file_buffered_write_one_page - Write a single page of data to an
> > + *	inode
> 
> kerneldoc doesn't permit line breaks in this context (unless it got
> fixed recently)

So you advocate a line exceeding 80 chars?

I contend that kerneldoc is a bad idea in many ways: it encourages people to
be lazy and to not write proper interface documentation.

David
