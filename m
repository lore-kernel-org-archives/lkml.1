Return-Path: <linux-kernel-owner+w=401wt.eu-S932202AbYHDHDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbYHDHDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 03:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbYHDHDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 03:03:38 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59617 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761277AbYHDHDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 03:03:37 -0400
Message-ID: <45488.166.70.238.45.1217832192.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:43:12 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 25/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware style debugger for Linux written by Jeffrey Vernon Merkey

--- a/Makefile	2008-08-03 16:09:50.000000000 -0600
+++ b/Makefile	2008-08-03 16:15:00.000000000 -0600
@@ -620,6 +620,7 @@

 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-$(CONFIG_MDB) += debug/

 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \


