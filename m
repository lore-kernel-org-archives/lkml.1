Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbZJYEFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbZJYEFL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 00:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbZJYEFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 00:05:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54880 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbZJYEFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 00:05:10 -0400
Date: Sun, 25 Oct 2009 00:05:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] tracefs
Message-ID: <20091025040503.GA15781@infradead.org>
References: <20091023004937.GA24035@kroah.com> <20091023053237.GA24359@elte.hu> <1256303528.20866.822.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256303528.20866.822.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 09:12:08AM -0400, Steven Rostedt wrote:
> Note, I wasn't talking about tie down the pretty-print formats. But we
> need to have a standard way to change them.

Which means to tie down it I think.  Once we do have a good enough
format those bits need to be locked down, with a way for adding new
attributes (either entirely new or better replacmeents for existing
ones with leaving the old ones in place for existing userspace).

In addition to the format description people have also asked for ABI
tracepoints which would lock down the actual trace format in the
the same way (only addition of new fields without removing or changing
existing ones).  For this to be actually useful some trace buffer
also needs to be exposed in an ABI-stable (that is non-debugfs way).

