Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbYKVAuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbYKVAuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 19:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbYKVAtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 19:49:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35993 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbYKVAtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 19:49:49 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4926F1AC.7090301@oracle.com>
References: <4926F1AC.7090301@oracle.com> <20081121002317.69e4fd11.akpm@linux-foundation.org> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144343.10667.530.stgit@warthog.procyon.org.uk> <3843.1227271421@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 24/45] CacheFiles: Add a hook to write a single page of data to an inode [ver #41]
Date: Sat, 22 Nov 2008 00:48:48 +0000
Message-ID: <19630.1227314928@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> wrote:

> I would have said that the prevailing comment style in struct
> address_space_operations is sketchy or limited or lacking.

Well, there's that too.

> I want useful comments.  I don't give a hoot whether they are in kernel-doc
> format or /* or //.  I'll even take them in a separate file if they are
> more about theory of operation (overview) instead of directly related
> to a struct or a function's operations, although some people want comments
> only in source files because that is more likely to be updated when
> needed.

I want to see proper interface documentation in Documentation.  Where an
interface is treated as a process, and where it's viewed from both sides where
others are expected both to implement it and to use it.

My opinion is that you should document any interface you propose on the theory
that if you can't explain your interface, why should you expect anyone to
understand what it does?

If I get some spare time, I intend to start writing it for interfaces that
already exist but don't have it yet.  It would then have to be up to those
that accept patches, from Linus on down, to force people to update
documentation when they submit a patch to alter, extend, add or remove an
interface.  Unfortunately, I don't see that as being likely to happen:-(

Sorry, but this is one of my favourite rants.

> If you don't document your own code, who will do it?  Probably nobody.

I do document my own code.  It's my responsibility to do so.

> Well, documentation can have consistent look and feel too, and it should.

Indeed.

David
