Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYH2GZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYH2GZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYH2GQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:16:06 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59526 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYH2GPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:33 -0400
Date: Thu, 28 Aug 2008 23:47:42 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5lg5b016144@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5 29/29] mdb: add /debug directory to main Makefile 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add /debug directory to main Makefile 

TO-DO

Add nested task gates to ia32 IDT for Linux to enable switching to a 
  good stack during exceptions.
X86_64 disssembler support
X86_64 register display support
ia64 disassembler support.
ia64 breakpoint support.
ia64 register display support.

 

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/Makefile	2008-08-28 14:19:37.000000000 -0600
+++ b/Makefile	2008-08-28 14:20:04.000000000 -0600
@@ -620,6 +620,7 @@
 
 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-$(CONFIG_MDB) += debug/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
