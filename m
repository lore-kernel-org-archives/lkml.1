Return-Path: <linux-kernel-owner+w=401wt.eu-S1760226AbYFNANK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226AbYFNANK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758374AbYFNAMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:12:25 -0400
Received: from ns.suse.de ([195.135.220.2]:34070 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758181AbYFNAMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:12:24 -0400
Date: Fri, 13 Jun 2008 17:10:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nick Piggin <npiggin@suse.de>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 03/47] Add rd alias to new brd ramdisk driver
Message-ID: <20080614001019.GC24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="add-rd-alias-to-new-brd-ramdisk-driver.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Nick Piggin <npiggin@suse.de>

upstream commit: efedf51c866130945b5db755cb58670e60205d83

Alias brd to rd in the hope of helping legacy users. Suggested by Jan.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/block/brd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -392,6 +392,7 @@ module_param(rd_size, int, 0);
 MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
+MODULE_ALIAS("rd");
 
 #ifndef MODULE
 /* Legacy boot options - nonmodular */

-- 
