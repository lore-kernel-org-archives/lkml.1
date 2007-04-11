Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbXDKP04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbXDKP04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbXDKP04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:26:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:6186 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbXDKP0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:26:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=l2t6JcLy77Ou+jkDr+EpNA6LoyKg3X4uGgaSug7lZFcnBCxqP1VUx2buTqyodNpUpaR05T+rbmAL9s5cqFphAblBz/1l+CliqwJpQ3QHLATLXn6Ivx90PLUEk6nrfZcXASO3alPXPbeWd2ytowS4l8a9rtWZt1J2dT5MKYt8uRA=
Date: Wed, 11 Apr 2007 20:58:46 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, alan@redhat.com
Subject: [KJ][PATCH] SPIN_LOCK_UNLOCKED cleanup in drivers/ata/pata_winbond.c
Message-ID: <20070411152846.GA11449@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

remove SPIN_LOCK_UNLOCKED, use DEFINE_SPINLOCK instead

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 pata_winbond.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)


diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index 6c11103..cfcd2a5 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -36,7 +36,7 @@ static int probe_winbond = 1;
 static int probe_winbond;
 #endif
 
-static spinlock_t winbond_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(winbond_lock);
 
 static void winbond_writecfg(unsigned long port, u8 reg, u8 val)
 {

-- 
Milind Arun Choudhary
