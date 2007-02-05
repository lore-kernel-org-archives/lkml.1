Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbXBEQ7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbXBEQ7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXBEQ7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:59:49 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:43181 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855AbXBEQ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:59:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=lNX1UWlu5G0zG/Roc7dDqwYwyovWXd/+iISqm/9rnLBwoiOmHUHAqynL1XRLASmd71PX6TpwDVtXaSiBvJy6zU7pIrLqhiPW05yZXSP/lUbanlncmBuRWMfKUX7yR7gKPKphyQ2HvzMBRNghHgv3k78YZd+/egFEmZqIMN5h3hM=
Date: Mon, 5 Feb 2007 18:59:33 +0200
To: jeffrey.t.kirsher@intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2.6.20] ixgb: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070205165933.GL3896@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205165429.GD3896@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A patch to use ARRAY_SIZE macro already defined in kernel.h.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/drivers/net/ixgb/ixgb_param.c b/drivers/net/ixgb/ixgb_param.c
index b27442a..26031fe 100644
--- a/drivers/net/ixgb/ixgb_param.c
+++ b/drivers/net/ixgb/ixgb_param.c
@@ -245,7 +245,7 @@ ixgb_validate_option(int *value, struct ixgb_option *opt)
 	return -1;
 }
 
-#define LIST_LEN(l) (sizeof(l) / sizeof(l[0]))
+#define LIST_LEN(l) ARRAY_SIZE(l)
 
 /**
  * ixgb_check_options - Range Checking for Command Line Parameters


-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
