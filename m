Return-Path: <linux-kernel-owner+w=401wt.eu-S2992721AbXEBE2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992721AbXEBE2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992726AbXEBE2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:28:45 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24879 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992721AbXEBE2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:28:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=ria7X/KVXfPL/Y0VvOxKqhECsaBgZ5aJxNtVNw+RdIKyxWqTPw5mLDHKeX9uM1YFC
	T1gYeVVkW+GdJ7UU5REFQ==
Date: Tue, 1 May 2007 21:28:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 06/10] i386: voyager: use __attribute_unused__
In-Reply-To: <Pine.LNX.4.64.0705012121350.19277@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705012122120.19277@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012120130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012120470.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012121350.19277@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace automatic variable instances of __attribute__((unused)) with
__attribute_unused__ in mca_nmi_hook().

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/i386/mach-voyager/voyager_basic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/i386/mach-voyager/voyager_basic.c b/arch/i386/mach-voyager/voyager_basic.c
--- a/arch/i386/mach-voyager/voyager_basic.c
+++ b/arch/i386/mach-voyager/voyager_basic.c
@@ -292,8 +292,8 @@ machine_emergency_restart(void)
 void
 mca_nmi_hook(void)
 {
-	__u8 dumpval __attribute__((unused)) = inb(0xf823);
-	__u8 swnmi __attribute__((unused)) = inb(0xf813);
+	__u8 dumpval __attribute_unused__ = inb(0xf823);
+	__u8 swnmi __attribute_unused__ = inb(0xf813);
 
 	/* FIXME: assume dump switch pressed */
 	/* check to see if the dump switch was pressed */
