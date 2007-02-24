Return-Path: <linux-kernel-owner+w=401wt.eu-S1752274AbXBXNB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbXBXNB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 08:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbXBXNB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 08:01:26 -0500
Received: from [194.112.174.227] ([194.112.174.227]:37905 "EHLO mail.hofr.at"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbXBXNB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 08:01:26 -0500
X-Greylist: delayed 1942 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Feb 2007 08:01:25 EST
Date: Sat, 24 Feb 2007 12:45:16 +0100 (CET)
From: Nicholas Mc Guire <der.herr@hofr.at>
To: linux-kernel@vger.kernel.org
Subject: typo in include/linux/irqflags.h ?
Message-ID: <Pine.LNX.4.60.0702241243270.1583@rtl14.hofr.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Hi !

Seems like there was a cut&past error in include/linux/riqflags.h.


- --- linux-2.6.20/include/linux/irqflags.h	2007-02-04 09:44:54.000000000 -0900
+++ linux-2.6.20xm/include/linux/irqflags.h	2008-01-27 20:29:26.000000000 -0900
@@ -91,6 +91,6 @@
  })

  #define irqs_disabled_flags(flags)	raw_irqs_disabled_flags(flags)
- -#endif		/* CONFIG_X86 */
+#endif		/* CONFIG_TRACE_IRQFLAGS_SUPPORT */

  #endif

thx !
hofrat
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFF4CVPnU7rXZKfY2oRAmrDAJ9eFu3APdl0Y5LoYoUAPGXzipx2wwCgl3gM
28KVNI1v+DM/LyTWEv2XhQc=
=aAnC
-----END PGP SIGNATURE-----
