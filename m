Return-Path: <linux-kernel-owner+w=401wt.eu-S934130AbXEERwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934130AbXEERwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934152AbXEERwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:52:21 -0400
Received: from holomorphy.com ([66.93.40.71]:40058 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934130AbXEERwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:52:20 -0400
Date: Sat, 5 May 2007 02:55:10 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Miller <davem@davemloft.net>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no, tgraf@suug.ch,
       James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu,
       akpm@linux-foundation.org, phillips@google.com
Subject: Re: [PATCH 00/40] Swap over Networked storage -v12
Message-ID: <20070505095510.GA19966@holomorphy.com>
References: <20070504102651.923946304@chello.nl> <20070504.122716.31641374.davem@davemloft.net> <20070505094300.GA9592@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505094300.GA9592@infradead.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2007 12:26:51 +0200, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>> There is a fundamental deadlock associated with paging;

On Fri, May 04, 2007 at 12:27:16PM -0700, David Miller wrote:
>> I know you'd really like people like myself to review this work, but a
>> set of 40 patches is just too much to try and digest at once
>> especially when I have other things going on.  When I have lots of
>> other things already on my plate, when I see a huge patch set like
>> this I have to just say "delete" because I don't kid myself since
>> I know I'll never get to it.
>> Sorry there's now way I can review this with my current workload.

On Sat, May 05, 2007 at 10:43:00AM +0100, Christoph Hellwig wrote:
> There also quite alot of only semi-related thing in there.  It would
> be much better to only do the network stack and iscsi parts first
> and leave nfs out for a while.  Especially as the former are definitively
> useful while I strongly doubt that for swap over nfs.

This is backward. As much as we hate it, the common case is swap over
nfs, essentially because that is/was how things were commonly set up
for other operating systems. I'm not a Solaris administrator, though,
so various disclaimers apply.


-- wli
