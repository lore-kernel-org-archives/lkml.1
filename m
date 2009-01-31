Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZAaKoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZAaKoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 05:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZAaKoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 05:44:07 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:33495 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZAaKoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 05:44:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=XtAhPxEFPzedcBBSye01ZHtaZQ0bSwPQ78ka3CfwYUJR8xhSXXZ8ZrT23WPIAaNDcc
         vymuWk6IzjpoQZ3lxy17NPrXbrSb255t+tBCu1oLFQwLi4F62I26BvA97PW01dYdreVd
         jUjerKfr2ycUeajitNKiiPfonbp5C51do4rk4=
Message-ID: <49842B72.8070405@gmail.com>
Date: Sat, 31 Jan 2009 11:44:02 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: i reaches -1, tested 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/staging/agnx/rf.c b/drivers/staging/agnx/rf.c
index 8294b6e..9e1e9d5 100644
--- a/drivers/staging/agnx/rf.c
+++ b/drivers/staging/agnx/rf.c
@@ -669,7 +669,7 @@ static inline void calibra_delay(struct agnx_priv *priv)
 	unsigned int i = 100;
 
 	wmb();
-	while (i--) {
+	while (--i) {
 		reg = (ioread32(ctl + AGNX_ACI_STATUS));
 		if (reg == 0x4000)
 			break;
