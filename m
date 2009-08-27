Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbZH0AbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbZH0AbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 20:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbZH0AbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 20:31:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbZH0AbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 20:31:01 -0400
Date: Wed, 26 Aug 2009 20:30:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, acme@redhat.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: blktrace ftrace plugin, was Re: Receive side performance issue
	with multi-10-GigE and NUMA
Message-ID: <20090827003047.GA30341@infradead.org>
References: <20090826181502.GC13632@elte.hu> <20090826190435.GC10816@hmsreliant.think-freely.org> <20090826190830.GF13632@elte.hu> <20090826.123631.79533250.davem@davemloft.net> <20090826194835.GA16508@elte.hu> <20090826202344.GE10816@hmsreliant.think-freely.org> <20090826204027.GA21159@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826204027.GA21159@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 10:40:27PM +0200, Ingo Molnar wrote:
> We are also converting non-trivial plugins to generic tracepoints. A 
> recent example are the system call tracepoints, but we also 
> converted blktrace and kmemtrace to generic tracepoints.

On something semi-related:  Any reason to keep the blktrace ftrace
plugin around?  I don't think there's much point in it.  It only got
added in 2.6.29, and all the blktrace tooling just uses the legacy
ioctls.  All new uses should just use the TRACE_EVENT output.
