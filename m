Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab0BMTsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:48:12 -0500
Received: from mail-yw0-f179.google.com ([209.85.211.179]:46150 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0BMTsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:48:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=T1tG9lGCv8nwtWcx1uNy/hA1KYHgeoF1BFGW7psULK3g+2cqFoO/2Ami+NbW0/fpL0
         oR7XhOj5aaiqgGmdDt+z9p11KydWViWby2P1KTZ96elWbIRoYzV96yAROCFd5srRMkhu
         DNYQZ9uEeNEnw+kez8Ri8x9GDX+uXAqt3Fgd4=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 00/10] ARM: ftrace: cleanups, Thumb-2, and dynamic ftrace
Date: Sun, 14 Feb 2010 01:18:28 +0530
Message-Id: <1266090518-31120-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.6.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains fixes and improvements to the ARM ftrace support.  It adds
Thumb-2 support and re-implements the dynamic ftrace support.

"ftrace: allow building without frame pointers" and "ftrace: pass KBUILD_CFLAGS
to record_mcount.pl" are non-ARM-specific ftrace patches which are required to
support the ARM functionality.

Cleanups / docs:

  ARM: ftrace: clean up mcount assembly indentation
  ARM: ftrace: document mcount formats

Thumb-2:

  ftrace: allow building without frame pointers
  ARM: ftrace: allow building without frame pointers
  ARM: ftrace: add ENDPROC annotations
  ARM: ftrace: add Thumb-2 support

Dynamic ftrace:

  ftrace: pass KBUILD_CFLAGS to record_mcount.pl
  ARM: ftrace: fix and update dynamic ftrace
  ARM: ftrace: add Thumb-2 support to dynamic ftrace
  ARM: ftrace: enable dynamic ftrace

 Makefile                       |    3 +
 arch/arm/Kconfig               |    2 +
 arch/arm/Kconfig.debug         |    5 +
 arch/arm/include/asm/ftrace.h  |   23 +++++-
 arch/arm/kernel/armksyms.c     |    2 +
 arch/arm/kernel/entry-common.S |  167 ++++++++++++++++++++++++-----------
 arch/arm/kernel/ftrace.c       |  188 +++++++++++++++++++++++++++++----------
 kernel/trace/Kconfig           |    2 +-
 scripts/Makefile.build         |    3 +-
 scripts/recordmcount.pl        |    2 +
 10 files changed, 295 insertions(+), 102 deletions(-)

