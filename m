Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbZKPXG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbZKPXG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZKPXG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:06:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbZKPXGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:06:25 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -next 0/3] x86 insn decoder test updates (Re: linux-next: Tree
	for October 29 (x86 posttest))
To: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Randy Dunlap <rdunlap@xenotime.net>, Jim Keniston <jkenisto@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Mon, 16 Nov 2009 18:06:11 -0500
Message-ID: <20091116230611.5250.86656.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the patches which update x86 instruction decoder build-time test.
As Stephen reported on linux-next, sometimes objdump decodes bad
instructions as normal. This will cause a false positive result on
x86 insn decoder test. This patches update the test as below;
 - Show more information with V=1
 - Show in which symbol the difference places.
 - Just warning instead of build failure.

Thank you,

---

Masami Hiramatsu (3):
      x86: insn decoder test shows build warning
      x86: Show symbol name if insn decoder test failed
      x86: Add verbose option to insn decoder test


 arch/x86/tools/Makefile       |    9 +++-
 arch/x86/tools/distill.awk    |    5 ++
 arch/x86/tools/test_get_len.c |   99 ++++++++++++++++++++++++++++++++++-------
 3 files changed, 95 insertions(+), 18 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
