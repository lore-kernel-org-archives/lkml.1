Return-Path: <linux-kernel-owner+w=401wt.eu-S936146AbXGMIuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936146AbXGMIuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762139AbXGMIuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:50:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57087 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761763AbXGMIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:50:04 -0400
Date: Fri, 13 Jul 2007 01:49:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: joe.jin@oracle.com, bill.irwin@oracle.com, linux-kernel@vger.kernel.org,
       gurudas.pai@oracle.com, zwane@arm.linux.org.uk
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070713014907.5e51a224.akpm@linux-foundation.org>
In-Reply-To: <20070713014349.a8305231.pj@sgi.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	<20070712221842.f5e47065.akpm@linux-foundation.org>
	<20070713064004.GA21833@joejin-pc.cn.oracle.com>
	<20070712234938.c77f3a48.akpm@linux-foundation.org>
	<20070712235707.a08f0d42.akpm@linux-foundation.org>
	<20070713012906.a6f63c90.pj@sgi.com>
	<20070713013819.0f8bd1ea.akpm@linux-foundation.org>
	<20070713014349.a8305231.pj@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 01:43:49 -0700 Paul Jackson <pj@sgi.com> wrote:

> > Sigh.  What crap.  I guess we leave it as-is.
> 
> That matches my conclusion.
> 
> The thought of exposing a bug in some user of this find bit code by
> tightening up the API to return == N, not >= N, scares poor little old
> me.  I can imagine a nasty bug coming from this
> 
> If someone bold enough and strong enough to slay such dragons came
> along, I'd gladly cheer them along.  But such people are a rare breed,
> and probably have bigger dragons to slay first.
> 

We could do this: add a little bitops torture-test and run that
unconditionally, nice and early.

Something for the young and keen amongst us...
