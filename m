Return-Path: <linux-kernel-owner+w=401wt.eu-S934828AbYBNBJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934828AbYBNBJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765632AbYBNBJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:09:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43575
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1765700AbYBNBJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:09:07 -0500
Date: Wed, 13 Feb 2008 17:09:38 -0800 (PST)
Message-Id: <20080213.170938.34536425.davem@davemloft.net>
To: linuxppc-dev@ozlabs.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4]: Respun LMB patches.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've taken into consideration the various feedback, and
ported the bug fix and other LMB patches posted recently
in an effort to keep the patch churn by others down wrt.
my moving of these files.

1) Use HAVE_LMB as suggested by Sam.

2) Fix potential build errors wrt. asm/prom.h dependencies.

   My algorithm was:

   a) If the file only included asm/lmb.h I added an include
      of both linux/lmb.c and asm/prom.h

   b) If the file already includes asm/prom.h, I merely
      changed the asm/lmb.h to linux/lmb.h

   Header include mimimizations can be done as followon patches.

3) Integrate Kumar Gala's initial region fix.

4) Integrate Becky Bruce's large physical addressing change,
   but using u64 instead of phys_addr_t.

It's all at:

	master.kernel.org:/pub/scm/linux/kernel/git/davem/lmb-2.6.git

like before.
