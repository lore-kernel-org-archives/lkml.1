Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbZKTRKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbZKTRKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZKTRKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:10:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbZKTRKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:10:52 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/2] x86 insn decoder test checking objdump version
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Randy Dunlap <rdunlap@xenotime.net>, Jim Keniston <jkenisto@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Fri, 20 Nov 2009 12:13:01 -0500
Message-ID: <20091120171301.6715.24229.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091117061352.GE30852@elte.hu>
References: <20091117061352.GE30852@elte.hu>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

Ingo Molnar wrote:
> We dont want to remove the build error: it helped us fix a number of
> real bugs in the decoder - instead please try to create a make based
> workaround based on binutils, to not run the test with binutils older
> than 2.19 or so.

Agreed, this patch checks objdump version and skip the test if it is older
than 2.19.

Thank you,

---

Masami Hiramatsu (2):
      x86: insn decoder test checks objdump version
      [BUGFIX] x86: Fix insn decoder test typos


 arch/x86/tools/Makefile       |   15 ++++++++++++---
 arch/x86/tools/chkobjdump.awk |   23 +++++++++++++++++++++++
 2 files changed, 35 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/tools/chkobjdump.awk

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
