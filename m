Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYKUKcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYKUKcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYKUKcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:32:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33824 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbYKUKcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:32:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081121001704.51e7d744.akpm@linux-foundation.org>
References: <20081121001704.51e7d744.akpm@linux-foundation.org> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144210.10667.11143.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/45] FS-Cache: Recruit a couple of page flags for cache management [ver #41]
Date: Fri, 21 Nov 2008 10:31:58 +0000
Message-ID: <18685.1227263518@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> ow, that hurt.  Every time someone does this I ask "how many are left"
> but nobody seems to know how to work it out.

Yeah, that worries me a bit too.  That why we looked at reclaiming PG_private.
The patches to do that didn't appear to be interesting, however.

> How many are left?

It depends on the configuration, but with maximum usage, 24 are used, except
on IA64 where 25 are used.

> I'd suggest that we make PagePrivate() go away completely, to prevent
> accidental usages from sneaking back in.  If that's practical.

Well, there are still some places where PG_private does need to be checked
individually.

David
