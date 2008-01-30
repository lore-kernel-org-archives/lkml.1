Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYA3Ikw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYA3Ikw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbYA3Iko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:40:44 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:37678 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbYA3Ikn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:40:43 -0500
Date: Wed, 30 Jan 2008 09:40:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH mm] Remove deprecation of a.out ELF interpreters
Message-ID: <20080130084041.GA8429@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 30 Jan 2008 08:34:24.0796 (UTC) FILETIME=[EB4B9DC0:01C8631A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew has already queued the patch to remove the support for a.out
ELF interpreters. So remove the deprecation with it too.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/Documentation/feature-removal-schedule.txt
===================================================================
--- linux.orig/Documentation/feature-removal-schedule.txt
+++ linux/Documentation/feature-removal-schedule.txt
@@ -107,17 +107,6 @@ Who:	Eric Biederman <ebiederm@xmission.c
 
 ---------------------------
 
-What:  a.out interpreter support for ELF executables
-When:  2.6.25
-Files: fs/binfmt_elf.c
-Why:   Using a.out interpreters for ELF executables was a feature for
-       transition from a.out to ELF. But now it is unlikely to be still
-       needed anymore and removing it would simplify the hairy ELF
-       loader code.
-Who:   Andi Kleen <ak@suse.de>
-
----------------------------
-
 What:	remove EXPORT_SYMBOL(kernel_thread)
 When:	August 2006
 Files:	arch/*/kernel/*_ksyms.c
