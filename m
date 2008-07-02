Return-Path: <linux-kernel-owner+w=401wt.eu-S1762918AbYGBNZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762918AbYGBNZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 09:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbYGBNZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 09:25:06 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:52379 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbYGBNZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:25:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=h1WJRKzT5OFkujPKnaRHzNyRkLbKoPr2fI3eTCf52YQUXlGhbObqHXjLEfRcCUPvLS
         gKv3PNG0KcEvMFeLRRIWA/r4o8Atc2ckUP+8zOe1YBF6pDnNzqokvnVsYjnB3TpPu2/x
         ibDf4mY7NLjfj7iNkI/kID3oi/SSXRPvEombI=
Subject: [PATCH]  drivers/net/wireless/iwlwifi/iwl-3945.c
From: "Darren Jenkins\\" <darrenrjenkins@gmail.com>
To: kernel Janitors <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: ipw2100-admin@linux.intel.com, yi.zhu@intel.com, reinette.chatre@intel.com
Content-Type: text/plain; charset=UTF-8
Date: Wed, 02 Jul 2008 11:37:27 +1000
Message-Id: <1214962647.18261.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

G'day people

Coverity CID: 2265 NEGATIVE_RETURNS

"rate" is of an unsigned type, and the code requires a signed type.
The following patch makes it so.

Only compile tested.

﻿Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 62a3d8f..31d38cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -449,7 +449,7 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 
 	if (print_summary) {
 		char *title;
-		u32 rate;
+		int rate;
 
 		if (hundred)
 			title = "100Frames";


