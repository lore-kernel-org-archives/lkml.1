Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbZJFLLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbZJFLLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 07:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbZJFLLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 07:11:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:37859 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823AbZJFLLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 07:11:19 -0400
Subject: Re: Latest vfs scalability patch
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20091006102604.GN5216@kernel.dk>
References: <20091006064919.GB30316@wotan.suse.de>
	 <20091006101414.GM5216@kernel.dk>  <20091006102604.GN5216@kernel.dk>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 13:10:38 +0200
Message-Id: <1254827438.21044.251.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 12:26 +0200, Jens Axboe wrote:

> I did a quick perf analysis on that, but only on 8 clients (64 clients
> basically causes perf to shit itself, it's just not functional).

Even when used with -a so that you profile each cpu? I can imagine the
cacheline contention from the inherited counters to render a 64 thread
machine less than usable?


