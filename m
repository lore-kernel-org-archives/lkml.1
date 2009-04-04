Return-Path: <linux-kernel-owner+w=401wt.eu-S1765481AbZDDAPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765481AbZDDAPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760033AbZDDAPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:15:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:54045 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759482AbZDDAPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:15:22 -0400
Message-ID: <49D6A692.6040400@kernel.org>
Date: Fri, 03 Apr 2009 17:15:14 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make wakeup_secondary_cpu_via_init static
References: <49D6A631.2020706@sun.com>
In-Reply-To: <49D6A631.2020706@sun.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -538,7 +538,7 @@ wakeup_secondary_cpu_via_nmi(int logical
 	return (send_status | accept_status);
 }
 
-int __devinit
+static int __devinit
 wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
