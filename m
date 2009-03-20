Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZCTSac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZCTSac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZCTSaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:30:22 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:45785 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbZCTSaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:30:22 -0400
Subject: Re: [PATCH 0/2] Make the Unevictable LRU available on NOMMU
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Howells <dhowells@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kosaki.motohiro@jp.fujitsu.com, torvalds@linux-foundation.org,
       peterz@infradead.org, nrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
       riel@surriel.com
In-Reply-To: <12759.1237566272@redhat.com>
References: <1237565305.27431.48.camel@lts-notebook>
	 <20090312100049.43A3.A69D9226@jp.fujitsu.com>
	 <20090313173343.10169.58053.stgit@warthog.procyon.org.uk>
	 <28c262360903131727l4ef41db5xf917c7c5eb4825a8@mail.gmail.com>
	 <12759.1237566272@redhat.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 20 Mar 2009 14:30:15 -0400
Message-Id: <1237573815.27431.122.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 16:24 +0000, David Howells wrote:
> Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> 
> > I just want to point out [again :)] that removing the ramfs pages from
> > the lru will prevent them from being migrated
> 
> This is less of an issue for NOMMU kernels, since you can't migrate pages that
> are mapped.


Agreed.  So, you could eliminate them [ramfs pages] from the lru for
just the nommu kernels, if you wanted to go that route.

Lee

