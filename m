Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbYHNGpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbYHNGpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYHNGih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:38:37 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38163 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYHNGiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:38:04 -0400
Date: Thu, 14 Aug 2008 00:14:39 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808140614.m7E6Ed6r006267@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 29/29] mdb: add /debug directory to main Makefile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add the /debug directory to the main Makefile for module-based kernel
debuggers.


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/Makefile	2008-08-13 14:22:11.000000000 -0600
+++ b/Makefile	2008-08-13 11:56:03.000000000 -0600
@@ -620,6 +620,7 @@
 
 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-$(CONFIG_MDB) += debug/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
