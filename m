Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbZJ1XOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbZJ1XOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 19:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZJ1XOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 19:14:49 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:26443 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZJ1XOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 19:14:48 -0400
Date: Wed, 28 Oct 2009 16:09:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] k8.h: add struct bootnode
Message-Id: <20091028160955.d27ccb16.randy.dunlap@oracle.com>
In-Reply-To: <20091028190643.627f10aa.sfr@canb.auug.org.au>
References: <20091028190643.627f10aa.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AE8D048.014F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

k8.h uses struct bootnode but does not #include a header file
for it, so provide a simple declaration for it.

arch/x86/include/asm/k8.h:13: warning: 'struct bootnode' declared inside parameter list
arch/x86/include/asm/k8.h:13: warning: its scope is only this definition or declaration, which is probably not what you want

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/include/asm/k8.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20091028.orig/arch/x86/include/asm/k8.h
+++ linux-next-20091028/arch/x86/include/asm/k8.h
@@ -4,6 +4,7 @@
 #include <linux/pci.h>
 
 extern struct pci_device_id k8_nb_ids[];
+struct bootnode;
 
 extern int early_is_k8_nb(u32 value);
 extern struct pci_dev **k8_northbridges;
