Return-Path: <linux-kernel-owner+w=401wt.eu-S935342AbXGMIoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935342AbXGMIoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762336AbXGMInx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:43:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46935 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761920AbXGMInw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:43:52 -0400
Date: Fri, 13 Jul 2007 01:43:49 -0700
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: joe.jin@oracle.com, bill.irwin@oracle.com, linux-kernel@vger.kernel.org,
       gurudas.pai@oracle.com, zwane@arm.linux.org.uk
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070713014349.a8305231.pj@sgi.com>
In-Reply-To: <20070713013819.0f8bd1ea.akpm@linux-foundation.org>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	<20070712221842.f5e47065.akpm@linux-foundation.org>
	<20070713064004.GA21833@joejin-pc.cn.oracle.com>
	<20070712234938.c77f3a48.akpm@linux-foundation.org>
	<20070712235707.a08f0d42.akpm@linux-foundation.org>
	<20070713012906.a6f63c90.pj@sgi.com>
	<20070713013819.0f8bd1ea.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Sigh.  What crap.  I guess we leave it as-is.

That matches my conclusion.

The thought of exposing a bug in some user of this find bit code by
tightening up the API to return == N, not >= N, scares poor little old
me.  I can imagine a nasty bug coming from this

If someone bold enough and strong enough to slay such dragons came
along, I'd gladly cheer them along.  But such people are a rare breed,
and probably have bigger dragons to slay first.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
