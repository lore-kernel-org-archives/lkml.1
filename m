Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYADWeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYADWeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbYADWei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:34:38 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:61244 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbYADWeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:34:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=J7iBYS3iNM0hCRfnrls+jWZjYa6xsTv45srMEPmo9ZZJ4xgz3m4qOuhDHV7se3g2UipTEeOb1zM2k5rfdM2fW7jYGinKqUkaDYvMNslvl7VFkHBOhGGUgsqbZADXYI2XtLK3V7iqAh6WG+fr1Cn2slNlurkKFh6NFeaH8yClvec=
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: fix compilation warning in 'iwl-4965.c'
Date: Fri, 4 Jan 2008 23:34:35 +0100
User-Agent: KMail/1.9.7
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com, linville@tuxdriver.com
References: <200801042305.55188.mboton@gmail.com>
In-Reply-To: <200801042305.55188.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801042334.36177.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, there's a new patch.

This patch fixes a compilation warning in 'iwl-4965.c'.

"warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long unsigned int’"

Signed-off-by: Miguel Botón <mboton@gmail.com

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 74999af..92237cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3616,7 +3616,7 @@ static void iwl4965_add_radiotap(struct iwl4965_priv *priv,
 	if (skb_headroom(skb) < sizeof(*iwl4965_rt)) {
 		if (net_ratelimit())
 			printk(KERN_ERR "not enough headroom [%d] for "
-			       "radiotap head [%d]\n",
+			       "radiotap head [%zd]\n",
 			       skb_headroom(skb), sizeof(*iwl4965_rt));
 		return;
 	}

-- 
	Miguel Botón
