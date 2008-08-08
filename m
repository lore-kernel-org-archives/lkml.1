Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbYHHBeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbYHHBeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYHHBeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:34:15 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:37026
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYHHBeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:34:14 -0400
Date: Fri, 8 Aug 2008 03:34:12 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 9/7] mm: fix mm_take_all_locks() locking order
Message-ID: <20080808013412.GT31535@duo.random>
References: <20080804130317.994042639@chello.nl> <1218108349.8625.25.camel@twins> <20080807214642.GQ31535@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807214642.GQ31535@duo.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 11:46:42PM +0200, Andrea Arcangeli wrote:
> furthermore I doubt it works because with regular kvm I get 57 vmas
> filebacked alone, did you test 8/7, I didn't yet but I can test if you

Correction: 57 are the vmas but counting with something less coarse
than grep lib |wc -l, there are less inodes backing those vmas than
the nesting limit, so 8/7 is ok for now (as long as check_deadlock
exists at least).

Thanks again!
