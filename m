Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbYE1SF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbYE1SF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 14:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYE1SFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 14:05:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:38553 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbYE1SFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 14:05:49 -0400
Message-ID: <483D9EF9.6000707@windriver.com>
Date: Wed, 28 May 2008 13:05:45 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] kgdb fixes for 2.6.26-rc4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2008 18:05:38.0810 (UTC) FILETIME=[6F5B5DA0:01C8C0ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for_linus branch at:
 
git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git
for_linus

The first patch makes use of the helper functions that were introduced
in the mainline kernel.

The second patch fixes the boot regression failures when using the
kgdb tests and CONFIG_DEBUG_RODATA.

Thanks,
Jason.

---
Harvey Harrison (1):
      kgdb: use common ascii helpers and put_unaligned_be32 helper

Jason Wessel (1):
      kgdbts: Use HW breakpoints with CONFIG_DEBUG_RODATA

 drivers/misc/kgdbts.c |   33 ++++++++++++++++++++++++++-------
 kernel/kgdb.c         |   16 ++++++----------
 2 files changed, 32 insertions(+), 17 deletions(-)

