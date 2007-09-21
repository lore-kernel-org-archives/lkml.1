Return-Path: <linux-kernel-owner+w=401wt.eu-S1764660AbXIUXMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764660AbXIUXMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbXIUXMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:12:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbXIUXMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:12:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1190403055.6721.3.camel@heimdal.trondhjem.org>
References: <1190403055.6721.3.camel@heimdal.trondhjem.org> <20070921144703.8323.50492.stgit@warthog.procyon.org.uk> <20070921144755.8323.45791.stgit@warthog.procyon.org.uk>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 10/22] CacheFiles: Add a hook to write a single page of data to an inode
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Sat, 22 Sep 2007 00:11:35 +0100
Message-ID: <10126.1190416295@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> So why do you need a new address space operation? AFAICS the generic
> implementation will work for pretty much everyone who supports the
> existing prepare_write()/commit_write().

Because Christoph decreed that I wasn't allowed to call prepare_write() and
commit_write() directly.  It's possible that the method should be in the
inode_operations rather than on the address space.

> Furthermore, you don't appear to supply any alternative "optimised"
> implementations...

Optimised in what fashion?

David
