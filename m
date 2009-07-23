Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbZGWAvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbZGWAvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 20:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZGWAva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 20:51:30 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:42328 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZGWAv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 20:51:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SGYyEZMFIzLGX9jV4KjlcG/kgEDlJy81tQc6FGH75JV35Ltdaq0qI1wWGai5pZ2Gaj
         NZDcFNOexxFIuvRA2Ho+2tsg7UGyw7M4O896yCgcce6pTzEiHM3/67FBULi13/GteLUB
         dGFjDQw6vgAJFqPlwEIsxrGxphYI2Ppol/oQk=
MIME-Version: 1.0
Date: Wed, 22 Jul 2009 21:51:28 -0300
Message-ID: <bad58e960907221751h4520c359u47b29edd77f02db1@mail.gmail.com>
Subject: PATCH: Removed useless variable in arch/x86/boot/tty.c puts()
From: Trevor Pace <trevorpace@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change: Removed needless counting integer.

Applies to kernel version 2.6.30.2.

Signed-off-by: Trevor Pace <tr212206@dal.ca>

=====================================================================

--- arch/x86/boot/tty.c	2009-07-22 19:59:33.000000000 -0300
+++ arch/x86/boot/tty.c	2009-07-22 21:37:25.000000000 -0300
@@ -35,11 +35,8 @@ void __attribute__((section(".inittext")

 void __attribute__((section(".inittext"))) puts(const char *str)
 {
-	int n = 0;
-	while (*str) {
+	while (*str)
 		putchar(*str++);
-		n++;
-	}
 }

 /*
