Return-Path: <linux-kernel-owner+w=401wt.eu-S938029AbXHJOFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938029AbXHJOFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932837AbXHJOFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:05:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299AbXHJOFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:05:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1186687557.6699.167.camel@heimdal.trondhjem.org>
References: <1186687557.6699.167.camel@heimdal.trondhjem.org> <1186683869.6699.136.camel@heimdal.trondhjem.org> <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com> <20070809160550.17906.40862.stgit@warthog.cambridge.redhat.com> <21984.1186685548@redhat.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] NFS: Use local caching [try #2]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Fri, 10 Aug 2007 15:04:40 +0100
Message-ID: <24071.1186754680@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> > > Dang, that's a lot of inlines... AFAICS, approx half of fs/nfs/fscache.h
> > > should really be moved into fscache.c.
> > 
> > If you wish.  It seems a shame since a lot of them have only one caller.
> 
> ...however it also forces you to export a lot of stuff which is really
> private to fscache.c (the atomics etc).

The atomics is actually a bad example.  These are referred to directly by part
of the table in fs/nfs/sysctl.c.  Is there a better way of exporting
statistics than through /proc/sys/ files?

David
