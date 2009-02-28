Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbZB1VAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbZB1VAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 16:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbZB1VAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 16:00:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52964 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbZB1VAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 16:00:33 -0500
Date: Sat, 28 Feb 2009 16:00:31 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE][PATCH 0 of 4] zedtrace, a general-purpose binary
	tracer
Message-ID: <20090228210031.GA8155@infradead.org>
References: <1235725238.8512.86.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235725238.8512.86.camel@charm-linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I played with it a bit and I really like the userspace with the
transport backend and a hakcy script language that many people know
for post-processing.

But looking at the kernel portions just shows again that the whole
tracepoint concept is utterly wrong.  We should not need the
zed_block.c/zed_sched.c/zed_workqueue.c but instead have those
tracing points directly annotated in the subsystems like using
markers, so that's it's self-contained and can be added by modules
without touching the rest of the kernel.

I know tracepoints are not your fault, but we really need to sort
that out for a nice tracing experience.

