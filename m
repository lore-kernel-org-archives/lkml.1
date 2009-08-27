Return-Path: <linux-kernel-owner+w=401wt.eu-S1751083AbZH0F01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751083AbZH0F01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 01:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbZH0F01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 01:26:27 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41451 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbZH0F00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 01:26:26 -0400
Date: Thu, 27 Aug 2009 07:26:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org, fweisbec@gmail.com,
       acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: blktrace ftrace plugin, was Re: Receive side performance issue
	with multi-10-GigE and NUMA
Message-ID: <20090827052628.GE12579@kernel.dk>
References: <20090826181502.GC13632@elte.hu> <20090826190435.GC10816@hmsreliant.think-freely.org> <20090826190830.GF13632@elte.hu> <20090826.123631.79533250.davem@davemloft.net> <20090826194835.GA16508@elte.hu> <20090826202344.GE10816@hmsreliant.think-freely.org> <20090826204027.GA21159@elte.hu> <20090827003047.GA30341@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827003047.GA30341@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26 2009, Christoph Hellwig wrote:
> On Wed, Aug 26, 2009 at 10:40:27PM +0200, Ingo Molnar wrote:
> > We are also converting non-trivial plugins to generic tracepoints. A 
> > recent example are the system call tracepoints, but we also 
> > converted blktrace and kmemtrace to generic tracepoints.
> 
> On something semi-related:  Any reason to keep the blktrace ftrace
> plugin around?  I don't think there's much point in it.  It only got
> added in 2.6.29, and all the blktrace tooling just uses the legacy
> ioctls.  All new uses should just use the TRACE_EVENT output.

Lets kill it.

-- 
Jens Axboe

