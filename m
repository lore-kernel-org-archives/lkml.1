Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbZGARWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbZGARWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZGARWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:22:07 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:37252 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZGARWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=wAgNlG1c3ZScGK1wD+8HYGAmczoV2C1Ds5iZ/ngkr0/KmZIk9uHgl9jMusSHeaqZKL
         FtT/oAP0Mn8+mKQFN/4SGyFd5kn/UdGkGr0Ga2EUfFlvhTexZQUVLBnVNalCG2+XiG8j
         n35Y9MHLki6S1xE8r6zqXweF41+Q+z8oURKUs=
Date: Wed, 1 Jul 2009 14:24:12 -0300
From: Rudy Matela <rudy.matela@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Spelling correction in HDLC/Frame Relay support routines
Message-ID: <20090701172412.GC8416@vacuum.larces.uece.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling correction in HDLC/Frame Relay support routines

Changed: /* the listed is sorted */
To: /* the list is sorted */

Signed-off-by: Rudy Matela <rudy.matela@gmail.com>
---

 drivers/net/wan/hdlc_fr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index bfa0161..48ec131 100644
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
 
