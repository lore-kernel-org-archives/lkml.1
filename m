Return-Path: <linux-kernel-owner+w=401wt.eu-S1761167AbZB0V0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167AbZB0V0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760260AbZB0VZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:25:47 -0500
Received: from gw.goop.org ([64.81.55.164]:40005 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759998AbZB0VZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:25:46 -0500
Message-ID: <49A85A4D.5040703@goop.org>
Date: Fri, 27 Feb 2009 13:25:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86: add forward decl for tss_struct
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its the correct thing to do before using the struct in a prototype.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 1a7bf39..643c59b 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -20,6 +20,7 @@
 struct task_struct; /* one of the stranger aspects of C forward declarations */
 struct task_struct *__switch_to(struct task_struct *prev,
 				struct task_struct *next);
+struct tss_struct;
 void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		      struct tss_struct *tss);
 


