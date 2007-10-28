Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbXJ1OYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbXJ1OYU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 10:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXJ1OYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 10:24:13 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:40805 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbXJ1OYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 10:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GF3BNsjSG07joKybk3htICUbfRUXl4TUvB6dg1403LW0d7VgqURsRfrQGBoWPnbswlDlqV4xM+fmRQjB3SZd9P2CuqSgt9kQW/7RybdSyFi3ZhASFN3otFur8WJDPV/41UqaSm/WMVyA4/4S7d5rS00yRIVF07uuUVNI72hGrSE=
Message-ID: <8b67d60710280724s761f1d29t9de57941a9800913@mail.gmail.com>
Date: Sun, 28 Oct 2007 14:24:10 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH - SH] Clean up maple bus code to supress compiler warning
Cc: linuxsh-dev@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The API for uevent has changed for 2.6.24 and this patch makes a
consequential clean up.

(Apols to linux-sh list users seeing this for the second time, I
should have included lkml first time round for completeness)

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index 161d102..e52a629 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -601,8 +601,7 @@ static int match_maple_bus_driver(struct device *devptr,
        return 0;
 }

-static int maple_bus_uevent(struct device *dev, char **envp,
-                           int num_envp, char *buffer, int buffer_size)
+static int maple_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
        return 0;
 }
