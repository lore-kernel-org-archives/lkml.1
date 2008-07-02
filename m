Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbYGAWf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbYGAWf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760976AbYGAWfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:35:08 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:4654 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760808AbYGAWfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=H//x1s/vQLkd2tXmg1X1/+g85sxyjqMXQ0vVORU+if7lMLCTxgr6qy/U8rNvuD0p7/
         9OtgniEEw1gq6sZjjsSaFl+Sl8TND7mJDuMezfIkMrj9SmKT35O7B69U46yN/F8vgexf
         qykq/BAvWmqHX4GL115PZCPy4S0IrQ53RBU5o=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 5/23] make section names compatible with -ffunction-sections -fdata-sections: blackfin
Date: Wed, 2 Jul 2008 02:35:07 +0200
User-Agent: KMail/1.8.2
Cc: Russell King <rmk@arm.linux.org.uk>, David Howells <dhowells@redhat.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807020235.08025.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes blackfin architecture.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/blackfin/kernel/vmlinux.lds.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/blackfin/kernel/vmlinux.lds.S	Wed Jul  2 00:45:51 2008
@@ -91,7 +91,7 @@
 		__sdata = .;
 		/* This gets done first, so the glob doesn't suck it in */
 		. = ALIGN(32);
-		*(.data.cacheline_aligned)
+		*(.cacheline_aligned.data)
 
 #if !L1_DATA_A_LENGTH
 		. = ALIGN(32);
