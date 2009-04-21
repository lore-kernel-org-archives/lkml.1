Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZDUI0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZDUI0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZDUIZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:25:45 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49599 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZDUIZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:25:44 -0400
Date: Tue, 21 Apr 2009 17:20:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.30-rc3
Message-ID: <20090421082036.GA15855@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.30

Which contains:

Paul Mundt (3):
      rtc: rtc-sh: clock framework support.
      sh: sh7722: Don't default enable the RTC clock.
      sh: sh7723: Don't default enable the RTC clock.

Toshinobu Sugioka (1):
      sh: Fix mmap2 for handling differing PAGE_SIZEs.

 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |    1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |    1 -
 arch/sh/kernel/sys_sh.c                |    9 ++++
 drivers/rtc/Kconfig                    |    2 +-
 drivers/rtc/rtc-sh.c                   |   67 +++++++++++++++++++++++--------
 5 files changed, 59 insertions(+), 21 deletions(-)
