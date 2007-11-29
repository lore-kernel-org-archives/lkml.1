Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbXLFMps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbXLFMps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbXLFMmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:45 -0500
Received: from nic2.axis.se ([193.13.178.10]:35730 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbXLFMmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:42:19 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <2ca49a2d8f87ae65aed05e69e17b288a56bc79d6.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2007 18:19:42 +0100
Subject: [PATCH 12/47] Remove unnecessary CVS log from cris/mm/init.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/mm/init.c |  111 ---------------------------------------------------
 1 files changed, 0 insertions(+), 111 deletions(-)

diff --git a/arch/cris/mm/init.c b/arch/cris/mm/init.c
index 0c833d1..4207a2b 100644
--- a/arch/cris/mm/init.c
+++ b/arch/cris/mm/init.c
@@ -6,117 +6,6 @@
  *
  *  Authors:  Bjorn Wesen (bjornw@axis.com)
  *
- *  $Log: init.c,v $
- *  Revision 1.11  2004/05/28 09:28:56  starvik
- *  Calculation of loops_per_usec moved because initialization order has changed
- *  in Linux 2.6.
- *
- *  Revision 1.10  2004/05/14 07:58:05  starvik
- *  Merge of changes from 2.4
- *
- *  Revision 1.9  2003/07/04 08:27:54  starvik
- *  Merge of Linux 2.5.74
- *
- *  Revision 1.8  2003/04/09 05:20:48  starvik
- *  Merge of Linux 2.5.67
- *
- *  Revision 1.7  2003/01/22 06:48:38  starvik
- *  Fixed warnings issued by GCC 3.2.1
- *
- *  Revision 1.6  2002/12/11 14:44:48  starvik
- *  Extracted v10 (ETRAX 100LX) specific stuff to arch/cris/arch-v10/mm
- *
- *  Revision 1.5  2002/11/18 07:37:37  starvik
- *  Added cache bug workaround (from Linux 2.4)
- *
- *  Revision 1.4  2002/11/13 15:40:24  starvik
- *  Removed the page table cache stuff (as done in other archs)
- *
- *  Revision 1.3  2002/11/05 06:45:13  starvik
- *  Merge of Linux 2.5.45
- *
- *  Revision 1.2  2001/12/18 13:35:22  bjornw
- *  Applied the 2.4.13->2.4.16 CRIS patch to 2.5.1 (is a copy of 2.4.15).
- *
- *  Revision 1.31  2001/11/13 16:22:00  bjornw
- *  Skip calculating totalram and sharedram in si_meminfo
- *
- *  Revision 1.30  2001/11/12 19:02:10  pkj
- *  Fixed compiler warnings.
- *
- *  Revision 1.29  2001/07/25 16:09:50  bjornw
- *  val->sharedram will stay 0
- *
- *  Revision 1.28  2001/06/28 16:30:17  bjornw
- *  Oops. This needs to wait until 2.4.6 is merged
- *
- *  Revision 1.27  2001/06/28 14:04:07  bjornw
- *  Fill in sharedram
- *
- *  Revision 1.26  2001/06/18 06:36:02  hp
- *  Enable free_initmem of __init-type pages
- *
- *  Revision 1.25  2001/06/13 00:02:23  bjornw
- *  Use a separate variable to store the current pgd to avoid races in schedule
- *
- *  Revision 1.24  2001/05/15 00:52:20  hp
- *  Only map segment 0xa as seg if CONFIG_JULIETTE
- *
- *  Revision 1.23  2001/04/04 14:35:40  bjornw
- *  * Removed get_pte_slow and friends (2.4.3 change)
- *  * Removed bad_pmd handling (2.4.3 change)
- *
- *  Revision 1.22  2001/04/04 13:38:04  matsfg
- *  Moved ioremap to a separate function instead
- *
- *  Revision 1.21  2001/03/27 09:28:33  bjornw
- *  ioremap used too early - lets try it in mem_init instead
- *
- *  Revision 1.20  2001/03/23 07:39:21  starvik
- *  Corrected according to review remarks
- *
- *  Revision 1.19  2001/03/15 14:25:17  bjornw
- *  More general shadow registers and ioremaped addresses for external I/O
- *
- *  Revision 1.18  2001/02/23 12:46:44  bjornw
- *  * 0xc was not CSE1; 0x8 is, same as uncached flash, so we move the uncached
- *    flash during CRIS_LOW_MAP from 0xe to 0x8 so both the flash and the I/O
- *    is mapped straight over (for !CRIS_LOW_MAP the uncached flash is still 0xe)
- *
- *  Revision 1.17  2001/02/22 15:05:21  bjornw
- *  Map 0x9 straight over during LOW_MAP to allow for memory mapped LEDs
- *
- *  Revision 1.16  2001/02/22 15:02:35  bjornw
- *  Map 0xc straight over during LOW_MAP to allow for memory mapped I/O
- *
- *  Revision 1.15  2001/01/10 21:12:10  bjornw
- *  loops_per_sec -> loops_per_jiffy
- *
- *  Revision 1.14  2000/11/22 16:23:20  bjornw
- *  Initialize totalhigh counters to 0 to make /proc/meminfo look nice.
- *
- *  Revision 1.13  2000/11/21 16:37:51  bjornw
- *  Temporarily disable initmem freeing
- *
- *  Revision 1.12  2000/11/21 13:55:07  bjornw
- *  Use CONFIG_CRIS_LOW_MAP for the low VM map instead of explicit CPU type
- *
- *  Revision 1.11  2000/10/06 12:38:22  bjornw
- *  Cast empty_bad_page correctly (should really be of * type from the start..
- *
- *  Revision 1.10  2000/10/04 16:53:57  bjornw
- *  Fix memory-map due to LX features
- *
- *  Revision 1.9  2000/09/13 15:47:49  bjornw
- *  Wrong count in reserved-pages loop
- *
- *  Revision 1.8  2000/09/13 14:35:10  bjornw
- *  2.4.0-test8 added a new arg to free_area_init_node
- *
- *  Revision 1.7  2000/08/17 15:35:55  bjornw
- *  2.4.0-test6 removed MAP_NR and inserted virt_to_page
- *
- *
  */
 
 #include <linux/init.h>
-- 
1.5.3.6.970.gd25430

