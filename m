Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZLGGW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZLGGW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 01:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZLGGWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 01:22:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35503 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbZLGGWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 01:22:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TuiTQkvNMDSa7gqZedudT/hM+schUBOoI/BRIx9dM649wtzQ/bFLLmi2ykeQDzws27
         IDCDBwM1TrR0K13CjsI7ju7WoNp6G9FqAKp9PcM2FVGu74EiNG7lawGxIyCcZ/XBpGyQ
         xwwjfk/xT62aQqhABAFtTl+KIlpqAJ0Dp9b0s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Walt <w41ter@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>
Subject: [GIT PULL] hw-breakpoints fixes
Date: Mon,  7 Dec 2009 07:22:55 +0100
Message-Id: <1260166977-5894-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

The first patch prevents from stack randomnesses in a breakpoint
definition.
The second fixes a ptrace regression reported by walt.

Thanks,
	Frederic
---

Frederic Weisbecker (2):
      hw-breakpoints: Zeroe the breakpoint attrs on initialization
      hw-breakpoints: Fix task-bound breakpoint slot allocation


 include/linux/hw_breakpoint.h |    2 +
 kernel/hw_breakpoint.c        |   74 +++++++++++++++++++++++++----------------
 2 files changed, 47 insertions(+), 29 deletions(-)
