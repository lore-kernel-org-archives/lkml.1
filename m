Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbZDMVBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbZDMVBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZDMVBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:01:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:33168 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbZDMVBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:01:23 -0400
Date: Mon, 13 Apr 2009 21:00:40 GMT
From: tip-bot for Alexander van Heukelum <heukelum@mailshack.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, heukelum@mailshack.com, heukelum@fastmail.fm,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, heukelum@mailshack.com, heukelum@fastmail.fm,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090413153924.GA20287@mailshack.com>
References: <20090413153924.GA20287@mailshack.com>
Subject: [tip:x86/apic] x86: fix function definitions after: x86: apic - introduce imcr_ helpers
Message-ID: <tip-5cda395f4a262788d8ed79ac8a26a2b821e5f751@git.kernel.org>
Git-Commit-ID: 5cda395f4a262788d8ed79ac8a26a2b821e5f751
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Apr 2009 21:00:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cda395f4a262788d8ed79ac8a26a2b821e5f751
Gitweb:     http://git.kernel.org/tip/5cda395f4a262788d8ed79ac8a26a2b821e5f751
Author:     Alexander van Heukelum <heukelum@mailshack.com>
AuthorDate: Mon, 13 Apr 2009 17:39:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 13 Apr 2009 22:57:44 +0200

x86: fix function definitions after: x86: apic - introduce imcr_ helpers

The patch "introduce imcr_ helpers" introduced good comments, but
also a few new compile warnings. This fixes the function definitions
to have a 'void' return type.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <20090413153924.GA20287@mailshack.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 9b849d4..4b48ff9 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -106,7 +106,7 @@ static int enabled_via_apicbase;
  * the BIOS or the operating system must switch out of
  * PIC Mode by changing the IMCR.
  */
-static inline imcr_pic_to_apic(void)
+static inline void imcr_pic_to_apic(void)
 {
 	/* select IMCR register */
 	outb(0x70, 0x22);
@@ -114,7 +114,7 @@ static inline imcr_pic_to_apic(void)
 	outb(0x01, 0x23);
 }
 
-static inline imcr_apic_to_pic(void)
+static inline void imcr_apic_to_pic(void)
 {
 	/* select IMCR register */
 	outb(0x70, 0x22);
