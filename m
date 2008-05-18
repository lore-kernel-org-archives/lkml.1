Return-Path: <linux-kernel-owner+w=401wt.eu-S1760347AbYERAy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347AbYERAy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 20:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYERAyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 20:54:19 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:41564 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752167AbYERAyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 20:54:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EG9kd9DNUq5jhIoK+cgRW1PuusXehmePvObS6nzze69DDqtH21eVnFydNnsWhL4e3YWoZ1EePBWMKHWZhcUTpKIapxZazsVPvvFefwdmIWkR5bO1/CAg4L2NyF8n7PWjX1518ulWDTdEMmyVFQgYIP4K0saChVX7f1I3d4WjeKc=  ;
X-YMail-OSG: E8Az0hAVM1kIefDYT7VMr2PR4N_E8TFDkwW2THlwZcaUrxywCWj_izagpT_vKfFKy8fShU_5TAJMJDvR2NAxstgD87OoV1QhkzBlWqiPUPDkmac.8X1eyWv8w29pEpNecGE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.26-rc2-git] gpio: pca953x driver handles pca9554 too
Date: Sat, 17 May 2008 17:39:57 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805171739.57655.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teach drivers/gpio/pca953x.c about PCA9554, another compatible chip.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- g26.orig/drivers/gpio/pca953x.c	2008-05-01 12:46:39.000000000 -0700
+++ g26/drivers/gpio/pca953x.c	2008-05-01 00:14:13.000000000 -0700
@@ -30,6 +30,7 @@ static const struct i2c_device_id pca953
 	{ "pca9537", 4, },
 	{ "pca9538", 8, },
 	{ "pca9539", 16, },
+	{ "pca9554", 8, },
 	{ "pca9555", 16, },
 	{ "pca9557", 8, },
 	/* REVISIT several pca955x parts should work here too */
