Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbYADWGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbYADWGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbYADWF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:05:59 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:54865 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbYADWF5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:05:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=Cwekx7zDWSeyir+LT4+rtfxyaz+T7XMr+LeLr30syRfuUCHAK/REfg3An0jupWwEMtjy4hFYVuC2OT7lSy+6EvXojYDxUBIoBfiDADYKhm0Af+0NBFOt7KmEAmQP/WFBsDJ8JOKf/v4QoFcgZjn6F5dATady5UxkJw3txhbFL64=
To: linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: fix compilation warning in 'iwl-4965.c'
Date: Fri, 4 Jan 2008 23:05:54 +0100
User-Agent: KMail/1.9.7
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com, linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801042305.55188.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a compilation warning in 'iwl-4965.c'.

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 74999af..92237cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3616,7 +3616,7 @@ static void iwl4965_add_radiotap(struct iwl4965_priv *priv,
 	if (skb_headroom(skb) < sizeof(*iwl4965_rt)) {
 		if (net_ratelimit())
 			printk(KERN_ERR "not enough headroom [%d] for "
-			       "radiotap head [%d]\n",
+			       "radiotap head [%ld]\n",
 			       skb_headroom(skb), sizeof(*iwl4965_rt));
 		return;
 	}

-- 
	Miguel Botón
