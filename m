Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbXIUXBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbXIUXBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763763AbXIUXBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:01:05 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:45221 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbXIUXBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:01:03 -0400
Date: Fri, 21 Sep 2007 16:00:31 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.7
Message-ID: <20070921230031.GB3906@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.7 kernel.
It contains a single security bugfix for the x86_64 architecture.
There is potential for local privilege escalation, so all x86_64 users
are certainly encouraged to upgrade.

CVE-2007-4573: x86_64: Zero extend all registers after ptrace in 32bit entry path.

I'll also be replying to this message with a copy of the patch between
2.6.22.6 and 2.6.22.7

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,
-chris

--------

 Makefile                     |    2 +-
 arch/x86_64/ia32/ia32entry.S |   18 +++++++++++++++---
 arch/x86_64/kernel/ptrace.c  |    4 ----
 3 files changed, 16 insertions(+), 8 deletions(-)

Summary of changes from v2.6.22.6 to v2.6.22.7
==============================================

Andi Kleen (1):
      x86_64: Zero extend all registers after ptrace in 32bit entry path.

Chris Wright (1):
      Linux 2.6.22.7

