Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbZJTQzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbZJTQzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 12:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbZJTQzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 12:55:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbZJTQzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 12:55:03 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 0/2] x86 insn decoder bugfixes
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 20 Oct 2009 12:55:18 -0400
Message-ID: <20091020165518.4145.94115.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are x86 insn decoder bugfixes.
I checked it with your config and allyesconfig too.

Thank you,

---

Masami Hiramatsu (2):
      x86: Add AES opcodes to opcode map
      x86: Fix group attribute decoding bug


 arch/x86/lib/inat.c             |    2 +-
 arch/x86/lib/x86-opcode-map.txt |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
