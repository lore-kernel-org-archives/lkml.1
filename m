Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbZHZSmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbZHZSmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZHZSmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:42:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48670 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZHZSmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:42:42 -0400
Date: Wed, 26 Aug 2009 14:42:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090826184236.GA24102@infradead.org>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090825162004.GA25058@Krystal> <20090825165912.GI6114@nowhere> <20090825173107.GJ6114@nowhere> <20090825183119.GC2448@Krystal> <1251267669.7538.1195.camel@twins> <20090826170812.GC21456@Krystal> <20090826184116.GA20283@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826184116.GA20283@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 02:41:16PM -0400, Christoph Hellwig wrote:
> We do not support system calls from kernelspace anymore.  All the
> macros to do real system calls are gone, and there are very very few
> places left calling sys_foo as normal function calls.
> 
> An how exactly is calling sys_foo as a normal function call different
> from calling do_foo or vfs_foo?

And if you really need to trace direct callers of sys_foo just put
a jprobe on it.

