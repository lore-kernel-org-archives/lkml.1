Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbYKRSlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbYKRSlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 13:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYKRSlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 13:41:14 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:34247 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYKRSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 13:41:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=RukoD+VTQ2NhZ/3FkxSagSk3rnK9+o1nbwJQZexusW9sh2/Fg0y1Qlqa0QGF/Pc1WU
         Y7JqrGqcvFMwoVUDDYmQLJrErDKP/ybovcn43pnQVMVWn5LPi0t8nnY/1uqhWxAkE43r
         g5jfpisedlB4s/CgYoBRX6SAK2CS/mlygbF/E=
Date: Tue, 18 Nov 2008 18:40:52 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andrew Morton <akpm@osdl.org>
Subject: [Patch] MODULE_UNLOAD should depend on PROC_FS
Message-ID: <20081118184052.GA24453@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The feature controlled by MODULE_UNLOAD uses proc interface, so it
should depend on PROC_FS.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
diff --git a/init/Kconfig b/init/Kconfig
index 226da27..fade39e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -871,6 +871,7 @@ config MODULE_FORCE_LOAD
 
 config MODULE_UNLOAD
 	bool "Module unloading"
+	depends on PROC_FS
 	help
 	  Without this option you will not be able to unload any
 	  modules (note that some modules may not be unloadable


