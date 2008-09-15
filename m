Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYIOHui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYIOHui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 03:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYIOHua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 03:50:30 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52496 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYIOHu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 03:50:29 -0400
Date: Mon, 15 Sep 2008 09:50:18 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: linux-ppc <linuxppc-dev@ozlabs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] powerpc: ignore generated vmlinux.lds
Message-ID: <20080915095018.1b16cd00@bull.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Add a .gitignore in arch/powerpc/kernel to ignore the generated
vmlinux.lds.

Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
---
 arch/powerpc/kernel/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
 create mode 100644 arch/powerpc/kernel/.gitignore

diff --git a/arch/powerpc/kernel/.gitignore b/arch/powerpc/kernel/.gitignore
new file mode 100644
index 0000000..c5f676c
--- /dev/null
+++ b/arch/powerpc/kernel/.gitignore
@@ -0,0 +1 @@
+vmlinux.lds
-- 
1.6.0.1.308.gede4c

