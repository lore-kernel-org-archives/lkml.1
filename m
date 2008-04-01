Return-Path: <linux-kernel-owner+w=401wt.eu-S1760106AbYDAVtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106AbYDAVtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbYDAVta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:49:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:8184 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbYDAVt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=SngJo1kfwqYdS+j7iaU7QoV+Phov343QRUMX1uNKi5OU/7HQ2e0otNzeKsiL/1xvWriBjzY33d5aHeSf7q3BNjHUz+M2T2a5pHY7C2Cx2CAWEz0tB97BNxLFvLGOJWsmK0u72focW7yEF6DQMcisAPBp6BQdZVkXU4KnfGS30BE=
From: Leonardo Potenza <lpotenza@inwind.it>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/atm/iphase.c: compilation warning fix
Date: Tue, 1 Apr 2008 23:49:29 +0200
User-Agent: KMail/1.9.7
Cc: chas@cmf.nrl.navy.mil, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804012349.29836.lpotenza@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonardo Potenza <lpotenza@inwind.it>

Removed the warning messages:
drivers/atm/iphase.c:961: warning: 'tcnter' defined but not used
drivers/atm/iphase.c:963: warning: 'xdump' defined but not used

tcnter and xdump() are used only in debug build

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
---

iphase.c |    2 ++
1 file changed, 2 insertions(+)

--- linux-2.6.orig/drivers/atm/iphase.c
+++ linux-2.6/drivers/atm/iphase.c
@@ -958,6 +958,7 @@ static void ia_suni_pm7345_init (IADEV *
 
 /***************************** IA_LIB END *****************************/
     
+#ifdef CONFIG_ATM_IA_DEBUG
 static int tcnter = 0;
 static void xdump( u_char*  cp, int  length, char*  prefix )
 {
@@ -992,6 +993,7 @@ static void xdump( u_char*  cp, int  len
     }
 
 }  /* close xdump(... */
+#endif /* CONFIG_ATM_IA_DEBUG */
 
   
 static struct atm_dev *ia_boards = NULL;  
