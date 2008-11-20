Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYKTV6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYKTV6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 16:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbYKTV5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 16:57:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54554 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbYKTV5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 16:57:50 -0500
Message-Id: <20081120215541.489725873@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 16:55:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/1] powerpc: make mcount a stub for dynamic ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

I have one more patch. I added it to the end of the ppc/ftrace branch.
The new way of handling the finding of mcounts means we do not need
to do anything in the mcount call itself. It should just be a stub
and when ftrace is enabled, it will change the caller sites to call
something other than mcount.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: ppc/ftrace


Steven Rostedt (1):
      powerpc: ftrace, do nothing in mcount call for dyn ftrace

----
 arch/powerpc/kernel/entry_32.S |   35 +----------------------------------
 arch/powerpc/kernel/entry_64.S |   12 ------------
 2 files changed, 1 insertions(+), 46 deletions(-)
