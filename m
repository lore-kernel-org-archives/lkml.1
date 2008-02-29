Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbYB2RSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbYB2RSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761535AbYB2RSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:18:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50698 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761528AbYB2RSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:18:30 -0500
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Kerrisk <michael.kerrisk@googlemail.com>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
In-Reply-To: <alpine.LFD.1.00.0802290907480.17889@woody.linux-foundation.org>
References: <1204119455.6242.403.camel@lappy>
	 <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>
	 <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>
	 <alpine.LFD.1.00.0802290907480.17889@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 18:18:08 +0100
Message-Id: <1204305488.6243.113.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 09:12 -0800, Linus Torvalds wrote:

> > 2. It provides a sane mechanism for an application to determine the
> > space available for argv+environ.  Formerly this space was an
> > invariant, advertised via sysconf(_SC_ARG_MAX).
> 
> ... and what's the point? We've never had it before, nobody has ever cared, 
> and the whole notion is just stupid. Why would we want to limit it? The 
> only thing that the kernel *cares* about is the stack size - any other 
> size limits are always going to be arbitrary.

Well, don't think of limiting it, but querying the limit.

Programs like xargs would need to know how much to stuff into argv
before starting a new invocation.


