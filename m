Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZCML45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZCML45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZCML4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:56:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33337 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbZCML4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:56:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090312100049.43A3.A69D9226@jp.fujitsu.com>
References: <20090312100049.43A3.A69D9226@jp.fujitsu.com> <20090311170207.1795cad9.akpm@linux-foundation.org> <28c262360903111735s2b0c43a3pd48fcf8d55416ae3@mail.gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: dhowells@redhat.com, Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, peterz@infradead.org,
       Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may get wrongly discarded
Date: Fri, 13 Mar 2009 11:53:02 +0000
Message-ID: <27074.1236945182@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> David, Could you please try following patch if you have NOMMU machine?
> it is straightforward porting to nommu.

Is this patch actually sufficient, though?  Surely it requires an alteration
to ramfs to mark the page as being unevictable?

David
