Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbYKGXLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbYKGXLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYKGXK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:10:58 -0500
Received: from fmailhost02.isp.att.net ([207.115.11.52]:41157 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYKGXK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:10:57 -0500
X-Originating-IP: [207.115.9.151]
From: f.duncan.m.haldane@att.net
To: grek@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 2.6.28-rc3] staging: Kconfig for ARCH=arm, h8300, cris
Date: Fri, 07 Nov 2008 23:10:55 +0000
Message-Id: <110720082310.7358.4914CAFE000C5EA900001CBE22230650029B0A02D29B9B0EBF0A020E0B040E08D203D2020E0C029A0BD200@att.net>
X-Mailer: AT&T Message Center Version 1 (Oct 30 2008)
X-Authenticated-Sender: Zi5kdW5jYW4ubS5oYWxkYW5lQGF0dC5uZXQ=
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new Kconfig option to build "staging" drivers (code in drivers/staging/) is seen in all except three architectures (arm, h8300, cris), because in these cases arch/$ARCH/Kconfig does NOT source drivers/Kconfig.

This patch adds the source "drivers/staging/Kconfig" to arch/$ARCH/Kconfig for these three exceptional cases. 

Signed-off-by: Duncan Haldane <duncan_h@users.sourceforge.net>

diff -uprN a/arch/arm/Kconfig b/arch/arm/Kconfig
--- a/arch/arm/Kconfig	2008-11-02 17:17:19.000000000 -0500
+++ b/arch/arm/Kconfig	2008-11-07 17:54:30.000000000 -0500
@@ -1276,6 +1276,8 @@ source "drivers/regulator/Kconfig"
 
 source "drivers/uio/Kconfig"
 
+source "drivers/staging/Kconfig"
+
 endmenu
 
 source "fs/Kconfig"
diff -uprN a/arch/cris/Kconfig b/arch/cris/Kconfig
--- a/arch/cris/Kconfig	2008-11-02 17:17:19.000000000 -0500
+++ b/arch/cris/Kconfig	2008-11-07 17:54:30.000000000 -0500
@@ -681,6 +681,8 @@ source "drivers/usb/Kconfig"
 
 source "drivers/uwb/Kconfig"
 
+source "drivers/staging/Kconfig"
+
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
diff -uprN a/arch/h8300/Kconfig b/arch/h8300/Kconfig
--- a/arch/h8300/Kconfig	2008-11-02 17:17:19.000000000 -0500
+++ b/arch/h8300/Kconfig	2008-11-07 17:54:30.000000000 -0500
@@ -220,6 +220,8 @@ source "drivers/uwb/Kconfig"
 
 endmenu
 
+source "drivers/staging/Kconfig"
+
 source "fs/Kconfig"
 
 source "arch/h8300/Kconfig.debug"
