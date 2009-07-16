Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbZGPOjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbZGPOjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbZGPOjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:39:39 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:40144 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757510AbZGPOji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:39:38 -0400
Date: Thu, 16 Jul 2009 10:39:17 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: [PATCH] mm: count only reclaimable lru pages
In-Reply-To: <1247754491.6586.23.camel@laptop>
Message-ID: <alpine.DEB.1.10.0907161037590.7930@gentwo.org>
References: <20090716133454.GA20550@localhost>  <alpine.DEB.1.10.0907160959260.32382@gentwo.org>  <20090716142533.GA27165@localhost> <1247754491.6586.23.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Peter Zijlstra wrote:

> > What would you suggest?  In fact I'm not totally comfortable with it.
> > Maybe it would be safer to simply stick with the old _lru_pages
> > naming?
>
> Nah, I like the reclaimable name, these pages are at least potentially
> reclaimable.
>
> lru_pages() is definately not correct anymore since you exclude the
> unevictable and possibly the anon pages.

Well lets at least add a comment at the beginning of the functions
explaining that these are potentially reclaimable and list some of the
types of pages that may not be reclaimable.

