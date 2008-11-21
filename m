Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYKUK0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYKUK0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYKUK0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:26:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60276 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbYKUK0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:26:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081121000913.6506d7b6.akpm@linux-foundation.org>
References: <20081121000913.6506d7b6.akpm@linux-foundation.org> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144145.10667.39594.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/45] Create a dynamically sized pool of threads for doing very slow work items [ver #41]
Date: Fri, 21 Nov 2008 10:24:00 +0000
Message-ID: <18617.1227263040@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> umm, if they're slow, why not create a kernel thread per operation? 
> Why add the thread pool?

Because if someone does a tar of, say, a kernel tree, that'll create one
thread per file...  This provides a limiter - and makes sure there are threads
immediately available.

David
