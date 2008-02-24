Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbYBXPqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbYBXPqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 10:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYBXPqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 10:46:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:33582 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbYBXPqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 10:46:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CFamkdY75T/3SkqgstnL0g83A3sL+0G+3gB4zyg0tPQoG32j4+Iw7nKT8l4b2KH3MfwDbK1pP7GZ+6STeVSMxKxHzuF/gmeWgEtNv0NhQtSYSnJ2iEnV7BQXh8fDhhDf2XgarKeU8EsYwETDuMyKeg7CbfF6yXt1D84/KipsWys=
Message-ID: <3a0f49600802240746q4fcc2979x56a91dd25ef606da@mail.gmail.com>
Date: Sun, 24 Feb 2008 16:46:01 +0100
From: "Gabor Czigola" <czigola@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] invert the axes for HDAPS on Lenovo R61i ThinkPads
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- /usr/src/linux-source-2.6.24/drivers/hwmon/hdaps.c  2008-02-08
02:20:38.000000000 +0100
+++ /tmp/hdaps.c        2008-02-24 16:42:52.000000000 +0100
@@ -527,6 +527,7 @@
        HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60"),
        HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad Z60m"),
        HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T61P"),
+       HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i"),
        HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R61"),
        HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T61"),
        { .ident = NULL }

-- 
Czigola, Gabor
