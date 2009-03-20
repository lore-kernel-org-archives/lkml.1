Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbZCTQ2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbZCTQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbZCTQ2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:28:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42081 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbZCTQ2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:28:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1237565305.27431.48.camel@lts-notebook>
References: <1237565305.27431.48.camel@lts-notebook> <20090312100049.43A3.A69D9226@jp.fujitsu.com> <20090313173343.10169.58053.stgit@warthog.procyon.org.uk> <28c262360903131727l4ef41db5xf917c7c5eb4825a8@mail.gmail.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: dhowells@redhat.com, Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kosaki.motohiro@jp.fujitsu.com, torvalds@linux-foundation.org,
       peterz@infradead.org, nrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
       riel@surriel.com
Subject: Re: [PATCH 0/2] Make the Unevictable LRU available on NOMMU
Date: Fri, 20 Mar 2009 16:24:32 +0000
Message-ID: <12759.1237566272@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> I just want to point out [again :)] that removing the ramfs pages from
> the lru will prevent them from being migrated

This is less of an issue for NOMMU kernels, since you can't migrate pages that
are mapped.

David
