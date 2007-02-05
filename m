Return-Path: <linux-kernel-owner+w=401wt.eu-S932520AbXBENsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbXBENsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932521AbXBENsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:48:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:52313 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520AbXBENsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 08:48:09 -0500
Date: Mon, 5 Feb 2007 14:48:02 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: linux-kernel@vger.kernel.org, Al Boldi <a1426z@gawab.com>
Subject: 2.6.20 doesn't compile with gcc-3.2.2
Message-ID: <Pine.LNX.4.58.0702051441370.3434@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX18+FG0CD4rHTMB/kX5bMeIeK2xMiVKhcDeubl3G5i6CmiRqTYlpdjIYeoI2LdYO7vIwj+RR7WBobckL6O50A+U4sy738Mi5yG1veO5eVX8xxw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi <a1426z@gawab.com> wrote:

> Doing the following results in an incomplete vmlinuz:

> # make bzlilo
> 
> objcopy: arch/i386/boot/compressed/vmlinux.bin: File truncated
> make[2]: *** [arch/i386/boot/compressed/vmlinux.bin] Error 1
> make[1]: *** [arch/i386/boot/compressed/vmlinux] Error 2
> make: *** [bzlilo] Error 2

> gcc version 3.2.2 (Mandrake Linux 9.1 3.2.2-3mdk)

I just compiled using gcc 3.3.5 (debian stable). Please verify that your 
disk is not full and gcc is the cause. If it is, this patch should do the 
trick: :)

--- ./Documentation/Changes~	2007-02-05 15:10:04.000000000 +0100
+++ ./Documentation/Changes	2007-02-05 15:10:04.000000000 +0100
@@ -29,5 +29,5 @@ hardware, for example, you probably need
 isdn4k-utils.
 
-o  Gnu C                  3.2                     # gcc --version
+o  Gnu C                  3.3                     # gcc --version
 o  Gnu make               3.79.1                  # make --version
 o  binutils               2.12                    # ld -v

-- 
Anything you do can get you shot, including nothing. 
