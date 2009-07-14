Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZGNORZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZGNORZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZGNORZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:17:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50336 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbZGNORY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:17:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1247579382.11921.7.camel@ht.satnam>
References: <1247579382.11921.7.camel@ht.satnam> <1247561931.2473.2.camel@ht.satnam> <20090709094430.23882.46013.stgit@warthog.procyon.org.uk> <1247561220.2473.0.camel@ht.satnam> <4131.1247577044@redhat.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: dhowells@redhat.com, Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       torvalds@osdl.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-afs@lists.infradead.org
Subject: Re: [PATCH] AFS: Fix compilation warning
Date: Tue, 14 Jul 2009 15:16:07 +0100
Message-ID: <4563.1247580967@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> > I don't see an 80-column wrap problem that you've removed.
> > 
> 
> ok here it is :
> 
> -               if (fid.vnode != vnode->fid.vnode) {
> -                       _debug("%s: dirent changed [%u != %u]",
> -                              dentry->d_name.name, fid.vnode,
> -                              vnode->fid.vnode);

Ah, I see.  I thought you meant there was a line of >80 chars that got fixed.

David
