Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbXEJJ2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbXEJJ2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbXEJJ2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:28:22 -0400
Received: from canuck.infradead.org ([209.217.80.40]:40620 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777AbXEJJ2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:28:21 -0400
Subject: Re: [PATCH] include files: convert "include" subdirectory to UTF-8
From: David Woodhouse <dwmw2@infradead.org>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <alpine.DEB.0.83.0704171345510.914@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704171345510.914@sigma.j-a-k-j.com>
Content-Type: multipart/mixed; boundary="=-6whiRsdSzYXBWpJEpXNB"
Date: Thu, 10 May 2007 10:28:17 +0100
Message-Id: <1178789297.28494.29.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6whiRsdSzYXBWpJEpXNB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 2007-04-17 at 13:53 -0400, John Anthony Kazos Jr. wrote:
> -** Copyright 1994 by Bj<94>rn Brauel
> +** Copyright 1994 by Bj”rn Brauel 

I think that file was cp437, and it should read 'Björn'.
(asm-m68k/atari*.h)

Also note that Arnaldo just put more legacy noise into CREDITS...

-- 
dwmw2

--=-6whiRsdSzYXBWpJEpXNB
Content-Disposition: inline; filename=fix-charset.patch
Content-Type: text/x-patch; name=fix-charset.patch; charset=UTF-8
Content-Transfer-Encoding: 8bit

diff --git a/CREDITS b/CREDITS
index 6829e91..273d72b 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2299,8 +2299,8 @@ E: acme@redhat.com
 W: http://oops.ghostprotocols.net:81/blog/
 P: 1024D/9224DF01 D5DF E3BB E3C8 BCBB F8AD  841A B6AB 4681 9224 DF01
 D: IPX, LLC, DCCP, cyc2x, wl3501_cs, net/ hacks
-S: R. Bras�lio Itiber�, 4270/1010 - �gua Verde
-S: 80240-060 - Curitiba - Paran�
+S: R. Brasílio Itiberê, 4270/1010 - Água Verde
+S: 80240-060 - Curitiba - Paraná
 S: Brazil
 
 N: Karsten Merker
diff --git a/include/asm-m68k/atarihw.h b/include/asm-m68k/atarihw.h
index 6211363..ecf007d 100644
--- a/include/asm-m68k/atarihw.h
+++ b/include/asm-m68k/atarihw.h
@@ -2,7 +2,7 @@
 ** linux/atarihw.h -- This header defines some macros and pointers for
 **                    the various Atari custom hardware registers.
 **
-** Copyright 1994 by Bjrn Brauel
+** Copyright 1994 by Björn Brauel
 **
 ** 5/1/94 Roman Hodek:
 **   Added definitions for TT specific chips.
diff --git a/include/asm-m68k/atariints.h b/include/asm-m68k/atariints.h
index ce6c445..5748e99 100644
--- a/include/asm-m68k/atariints.h
+++ b/include/asm-m68k/atariints.h
@@ -1,7 +1,7 @@
 /*
 ** atariints.h -- Atari Linux interrupt handling structs and prototypes
 **
-** Copyright 1994 by Bjrn Brauel
+** Copyright 1994 by Björn Brauel
 **
 ** 5/2/94 Roman Hodek:
 **   TT interrupt definitions added.

--=-6whiRsdSzYXBWpJEpXNB--

