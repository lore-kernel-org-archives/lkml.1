Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbYGFUrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbYGFUrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbYGFUrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:47:37 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:40123 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbYGFUrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:47:37 -0400
Date: Sun, 6 Jul 2008 16:47:27 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove obsolete content from include/linux/init.h.
Message-ID: <alpine.LFD.1.10.0807061645490.4848@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove apparently obsolete content from init.h referring to gcc 2.9x
and to "no_module_init".

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  AFAICT, there is no value to those comments anymore, but i'm willing
to be corrected.

diff --git a/include/linux/init.h b/include/linux/init.h
index 21d658c..42ae954 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -275,13 +275,7 @@ void __init parse_early_param(void);

 #define security_initcall(fn)		module_init(fn)

-/* These macros create a dummy inline: gcc 2.9x does not count alias
- as usage, hence the `unused function' warning when __init functions
- are declared static. We use the dummy __*_module_inline functions
- both to kill the warning and check the type of the init/cleanup
- function. */
-
-/* Each module must use one module_init(), or one no_module_init */
+/* Each module must use one module_init(). */
 #define module_init(initfn)					\
 	static inline initcall_t __inittest(void)		\
 	{ return initfn; }					\


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
