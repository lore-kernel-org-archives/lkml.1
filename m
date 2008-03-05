Return-Path: <linux-kernel-owner+w=401wt.eu-S1765484AbYCEBTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765484AbYCEBTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934358AbYCEBRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:17:46 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:28059 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934351AbYCEBRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:17:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YEAoEomNg4mZqoMPnbpwGK33oPmJZHo6+LaejyZ0eeUX8u/WjBIxc6FCI2Q6jZteoQFhNuLbwxvkfV9rKWgP14ex3wAwQLPlF+dgcoUAkNpgBTC8F9iMF8vccechZxfPtLOsbyjeg+EwnXRWjqi/vF/yNfBuEI95zbbEP/sn7rg=
Subject: [PATCH 4/9] net: replace __inline with inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 17:17:18 -0800
Message-Id: <1204679838.5698.70.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wan/sbni.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index 15d5c58..e59255a 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -751,7 +751,7 @@ upload_data( struct net_device  *dev,  unsigned  framelen,  unsigned  frameno,
 }
 

-static __inline void
+static inline void
 send_complete( struct net_local  *nl )
 {
 #ifdef CONFIG_SBNI_MULTILINE
-- 
1.5.4.3.500.g83a2c


