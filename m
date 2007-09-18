Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbXIRSZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbXIRSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbXIRSZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:25:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630AbXIRSZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:25:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1190138621.6656.39.camel@heimdal.trondhjem.org>
References: <1190138621.6656.39.camel@heimdal.trondhjem.org> <336243.38765.qm@web36610.mail.mud.yahoo.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: dhowells@redhat.com, casey@schaufler-ca.com, viro@ftp.linux.org.uk,
       hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Credentials test patch
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 18 Sep 2007 19:24:45 +0100
Message-ID: <6388.1190139885@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> > What I don't really understand is what value is gained by this exercise.
> > Are the savings sufficiently significant to justify the effort?
> 
> It is not about savings, but about new functionality. Basically, the
> existence of reference-counted credentials will allow AFS and NFS to
> cache that information and use it for deferred writes etc.

And also make it easier for cachefiles and hopefully NFSd to override the
active security.

There's a comment somewhere in, I think, the SunRPC code in the Linux kernel
bemoaning the lack of this very feature:-)

David
