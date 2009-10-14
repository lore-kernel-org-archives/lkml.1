Return-Path: <linux-kernel-owner+w=401wt.eu-S1761708AbZJNDFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761708AbZJNDFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 23:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759814AbZJNDFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 23:05:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58202 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759704AbZJNDFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 23:05:19 -0400
Message-Id: <20091014030225.271734317@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Oct 2009 23:02:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] powerpc/ftrace: linker fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Benjamin,

Please pull the latest ppc/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
ppc/ftrace


Steven Rostedt (2):
      powerpc/ftrace: show real return addresses in modules
      powerpc64/ftrace: use PACA to retrieve TOC in mod_return_to_handler

----
 arch/powerpc/kernel/entry_64.S |    3 +--
 arch/powerpc/kernel/process.c  |   10 +++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)
