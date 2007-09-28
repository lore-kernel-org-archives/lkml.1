Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbXI1SxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbXI1SxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXI1SxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:53:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47470 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbXI1SxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:53:03 -0400
Subject: Re: A unresponsive file system can hang all I/O in the system on
	linux-2.6.23-rc6 (dirty_thresh problem?)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Chakri n <chakriin5@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net
In-Reply-To: <20070928114930.2c201324.akpm@linux-foundation.org>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	 <20070927235034.ae7bd73d.akpm@linux-foundation.org>
	 <1190998853.6702.17.camel@heimdal.trondhjem.org>
	 <20070928114930.2c201324.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 20:48:59 +0200
Message-Id: <1191005339.18147.89.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-09-28 at 11:49 -0700, Andrew Morton wrote:

> Do you know where the stalls are occurring?  throttle_vm_writeout(), or via
> direct calls to congestion_wait() from page_alloc.c and vmscan.c?  (running
> sysrq-w five or ten times will probably be enough to determine this)

would it make sense to instrument congestion_wait() callsites with
vmstats?

