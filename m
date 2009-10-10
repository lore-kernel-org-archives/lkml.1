Return-Path: <linux-kernel-owner+w=401wt.eu-S934408AbZJJRmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934408AbZJJRmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 13:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934351AbZJJRmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 13:42:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934320AbZJJRms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 13:42:48 -0400
Date: Sat, 10 Oct 2009 10:41:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ehrhardt Christian <ehrhardt@linux.vnet.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] mm: make VM_MAX_READAHEAD configurable
Message-Id: <20091010104111.547d8abe.akpm@linux-foundation.org>
In-Reply-To: <20091010124042.GA9179@localhost>
References: <1255087175-21200-1-git-send-email-ehrhardt@linux.vnet.ibm.com>
	<1255090830.8802.60.camel@laptop>
	<20091009122952.GI9228@kernel.dk>
	<20091009143124.1241a6bc.akpm@linux-foundation.org>
	<20091010105333.GR9228@kernel.dk>
	<20091010124042.GA9179@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Oct 2009 20:40:42 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:

> > not sure if it attempts to do anything based on how quickly
> > the device is doing IO. Wu?
> 
> Not for current kernel.  But in fact it's possible to estimate the
> read speed for each individual sequential stream, and possibly drop
> some hint to the IO scheduler: someone will block on this IO after 3
> seconds. But it may not deserve the complexity.

Well, we have a test case.  Would any of your design proposals address
the performance problem which motivated the s390 guys to propose this
patch?

