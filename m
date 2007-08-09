Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbXHISWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbXHISWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbXHISWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:22:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbXHISWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:22:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0708091114180.19611@us.intercode.com.au>
References: <Pine.LNX.4.64.0708091114180.19611@us.intercode.com.au> <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com> <20070809160535.17906.59852.stgit@warthog.cambridge.redhat.com>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] CacheFiles: Permit an inode's security ID to be obtained [try #2]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Thu, 09 Aug 2007 19:21:21 +0100
Message-ID: <21381.1186683681@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > +	u32 (*inode_get_secid)(struct inode *inode);
> 
> To maintain API consistency, please return an int which only acts as an 
> error code, and returning the secid via a *u32 function parameter.

Does that apply to *all* the functions, irrespective of whether or not they
return an error?

David
