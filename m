Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbZF0SgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbZF0SgB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 14:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZF0Sfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 14:35:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45454 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZF0Sfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 14:35:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090627125412.GA1667@cmpxchg.org>
References: <20090627125412.GA1667@cmpxchg.org> <3901.1245848839@redhat.com> <20090624023251.GA16483@localhost> <20090620043303.GA19855@localhost> <32411.1245336412@redhat.com> <20090517022327.280096109@intel.com> <2015.1245341938@redhat.com> <20090618095729.d2f27896.akpm@linux-foundation.org> <7561.1245768237@redhat.com> <26537.1246086769@redhat.com> 
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: dhowells@redhat.com, Wu Fengguang <fengguang.wu@intel.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: Found the commit that causes the OOMs
Date: Sat, 27 Jun 2009 19:35:26 +0100
Message-ID: <28486.1246127726@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> wrote:

> This is from your OOM-run dmesg, David:
> 
>   Adding 32k swap on swapfile22.  Priority:-21 extents:1 across:32k
>   Adding 32k swap on swapfile23.  Priority:-22 extents:1 across:32k
>   Adding 32k swap on swapfile24.  Priority:-23 extents:3 across:44k
>   Adding 32k swap on swapfile25.  Priority:-24 extents:1 across:32k
> 
> So we actually have swap?  Or are those removed again before the OOM?

That's merely a transient situation caused by the LTP swapfile tests.
Ordinarily, my test machine does not have swap.  At the time the OOMs occur
there is no swapspace and the msgctl9 or msgctl11 tests are usually being run.

> The following patch should improve on that.

I can give it a spin when I get home later.

David
