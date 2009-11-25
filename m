Return-Path: <linux-kernel-owner+w=401wt.eu-S964805AbZKYNWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964805AbZKYNWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934660AbZKYNWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:22:11 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:36992 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934657AbZKYNWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=eltZHxrF2/4wB+MhiEBQUBXyg7mlbmlnQ+VMA+AFo3lT4+LWSs8nb6h841lUZV80Il
         tCq1k1SlaK56bLfqphcr1R++v/65TWSd9fUheWtIec2g5FeqpzhA8uWUL4aGpqhBODPT
         MH0TS/TrbkOUrLhyz1UAiJFEvqxtct65oydWE=
Date: Wed, 25 Nov 2009 10:20:20 -0300
From: Rudy Matela <rudy.matela@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Spelling correction in HDLC/Frame Relay support routines
Message-ID: <20091125132020.GA22390@vacuum.larces.uece.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling correction in HDLC/Frame Relay support routines

Changed: /* the listed is sorted */
To: /* the list is sorted */

Signed-off-by: Rudy Matela <rudy.matela@gmail.com>
---

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 840cff7..4d4c543 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -182,7 +182,7 @@ static inline pvc_device* find_pvc(hdlc_device *hdlc, u16 dlci)
 		if (pvc->dlci == dlci)
 			return pvc;
 		if (pvc->dlci > dlci)
-			return NULL; /* the listed is sorted */
+			return NULL; /* the list is sorted */
 		pvc = pvc->next;
 	}
 
