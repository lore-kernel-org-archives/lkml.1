Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbZABNQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbZABNQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 08:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbZABNQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 08:16:09 -0500
Received: from smtp.tal.de ([81.92.1.5]:60028 "EHLO smtp.tal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756424AbZABNQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 08:16:08 -0500
From: ib@wupperonline.de (Ingo Brueckl)
Date: Fri, 02 Jan 2009 14:07:00 +0100
Subject: [PATCH] section mismatch
X-Mailer: blueMail 1.4 (SlipDoor 2.2)
Message-ID: <495e1180@wupperonline.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch has already been suggested by someone named
linuxtwid...@gmail.com but hasn't been applied yet.

It is beyond my scope so could please somebody confirm whether this is the
right thing to do?


fix section mismatch warning at compile time in vmlinux.o(.cpuinit.data+0x0)

Signed-off-by: Ingo Brueckl <ib@wupperonline.de>

--- linux-2.6.28/arch/x86/kernel/head_32.S.orig	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/arch/x86/kernel/head_32.S	2009-01-02 13:22:45.000000000 +0100
@@ -596,6 +596,7 @@ ignore_int:

 .section .cpuinit.data,"wa"
 .align 4
+__REFDATA
 ENTRY(initial_code)
 	.long i386_start_kernel
