Return-Path: <linux-kernel-owner+w=401wt.eu-S1760249AbYHDCix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbYHDCix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932075AbYHDCfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:35:14 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44603 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbYHDCfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:35:12 -0400
Message-ID: <57607.166.70.238.45.1217816090.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 3 Aug 2008 20:14:50 -0600 (MDT)
Subject: [PATCH 2.6.26 25/25] mdb: Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware Style Debugger for Linux written by Jeffrey Vernon Merkey

--- linux-2.6.26/Makefile	2008-07-13 15:51:29.000000000 -0600
+++ linux-2.6.26-mdb/Makefile	2008-08-03 12:49:01.000000000 -0600
@@ -608,6 +608,7 @@

 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-$(CONFIG_MDB) += debug/

 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \


By making a contribution to this project, I certify that the contribution
was created in whole or in part by me and I have the right to submit it
under the open source license indicated in the file

Jeffrey Vernon Merkey




