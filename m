Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbYBRKDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbYBRKDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYBRKDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:03:15 -0500
Received: from hall.aurel32.net ([88.191.38.19]:58051 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622AbYBRKDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:03:13 -0500
Date: Mon, 18 Feb 2008 11:02:57 +0100
From: Aurelien Jarno <aurelien@aurel32.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Adrian Bunk <bunk@kernel.org>, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>, ralf@linux-mips.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [SSB] PCI core driver: use new SPROM data structure
Message-ID: <20080218100257.GB22519@hall.aurel32.net>
Mail-Followup-To: Aurelien Jarno <aurelien@aurel32.net>,
	Michael Buesch <mb@bu3sch.de>, Adrian Bunk <bunk@kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>, ralf@linux-mips.org,
	linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
References: <20080217200947.GH1403@cs181133002.pp.htv.fi> <20080218074944.GA9317@hall.aurel32.net> <20080218100126.GA22519@hall.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080218100126.GA22519@hall.aurel32.net>
X-Mailer: Mutt 1.5.13 (2006-08-11)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch the SSB PCI core driver to the new SPROM data structure now that
the old one has been removed.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
---
 drivers/ssb/driver_pcicore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 2faaa90..191db7a 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -362,7 +362,7 @@ static int pcicore_is_in_hostmode(struct ssb_pcicore *pc)
 	    chipid_top != 0x5300)
 		return 0;
 
-	if (bus->sprom.r1.boardflags_lo & SSB_PCICORE_BFL_NOPCI)
+	if (bus->sprom.boardflags_lo & SSB_PCICORE_BFL_NOPCI)
 		return 0;
 
 	/* The 200-pin BCM4712 package does not bond out PCI. Even when
-- 
1.5.4.1

-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
