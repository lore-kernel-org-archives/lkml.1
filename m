Return-Path: <linux-kernel-owner+w=401wt.eu-S1761582AbZLJVbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582AbZLJVbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761215AbZLJVbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:31:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58130 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761043AbZLJVbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:31:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] asm-generic header fixes
Date: Thu, 10 Dec 2009 22:30:39 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       liqin.chen@sunplusct.com, Mike Frysinger <vapier.adi@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912102230.40258.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/ttq2hG+mXke70B952wg/L413hzuKv/CJluJp
 KwmHH0WN32L/vMJjsjsgOn4DCRko38uX82jYhM060FXJNYPx7f
 oDCSZ9nsIzpV1FV7V0nLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the asm-generic tree from

git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git master

Very small updates and bug fixes only.

Thanks,

	Arnd

----
Arnd Bergmann (5):
  lib/checksum.c: use 32-bit arithmetic consistently
  lib/checksum.c: make do_csum optional
  lib/checksum: fix one more thinko
  asm-generic: add sys_accept4 to unistd.h
  asm-generic: add sys_recvmmsg to unistd.h

Chen Liqin (1):
  asm-generic: Fix typo in asm-generic/unistd.h.

Mike Frysinger (1):
  asm-generic/gpio.h: add some forward decls of the device struct

 include/asm-generic/gpio.h   |    3 +++
 include/asm-generic/unistd.h |   10 +++++++---
 lib/checksum.c               |   14 ++++++++------
 3 files changed, 18 insertions(+), 9 deletions(-)
