Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbZFOPP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbZFOPP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbZFOPPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:15:52 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:37828 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZFOPPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:15:51 -0400
Date: Mon, 15 Jun 2009 17:18:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Giacomo A. Catenazzi" <cate@debian.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090615151809.GA13872@uranus.ravnborg.org>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <20090611185049.GB7658@uranus.ravnborg.org> <4A364F90.7080807@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A364F90.7080807@debian.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Kernels don't fit well in distribution models.
> We have distribution since 15 (and more) years, but still with
> hackish support for kernels.

Because the source are in the same git tree as the kernel does
not require the source to be considered a kernel.

You are talking from the wrong assumption that because the
source live in the git tree of the kernel it has hard
dependencies on that particular kernel.
This is wrong. There is the same requirements about being
backward/forward compatible as if the tool
lived in a git tree outside the kernel.

What we achieve by letting the userspace tools live inside
the kernel are:
- Kernel hacker tools are avaialble for the kernel hackers
- The tools are easy to upgrade when we add new stuff to the kernel
- We know that the updates are done upstream
- We have the kernel base of developers at easy reach,
  no need to build up a new development community

	Sam
