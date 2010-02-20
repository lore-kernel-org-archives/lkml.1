Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab0BTA3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:29:44 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64008 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab0BTA3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:29:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=jN9bQvXVPLdoxyB0hUSqLXL14JOxNUn+sDQeX34cXFeS7R6Zz5Y9raTRE1w0w6PQ0G
         7fblV1vvEv5+RcMO1NnpYc6osfjA3geHQSll7evqKdUxmdaEgIF7pQdxr3CRcl9fprtu
         aH0C5chsmd/VMMFFFwiL79ygIoJUS1ZX581sE=
Message-ID: <4B7F2EC7.6000305@gmail.com>
Date: Sat, 20 Feb 2010 01:37:27 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, geert@linux-m68k.org
Subject: [PATCH] m68k,m68knommu: missing asterisk?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An asterisk was missing.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Correct?

 arch/m68k/include/asm/apollohw.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/apollohw.h b/arch/m68k/include/asm/apollohw.h
index a1373b9..87e0cc4 100644
--- a/arch/m68k/include/asm/apollohw.h
+++ b/arch/m68k/include/asm/apollohw.h
@@ -94,7 +94,7 @@ extern u_long timer_physaddr;
 
 #define sio01 ((*(volatile struct SCN2681 *)(IO_BASE + sio01_physaddr)))
 #define sio23 ((*(volatile struct SCN2681 *)(IO_BASE + sio23_physaddr)))
-#define rtc (((volatile struct mc146818 *)(IO_BASE + rtc_physaddr)))
+#define rtc ((*(volatile struct mc146818 *)(IO_BASE + rtc_physaddr)))
 #define cpuctrl (*(volatile unsigned int *)(IO_BASE + cpuctrl_physaddr))
 #define pica (IO_BASE + pica_physaddr)
 #define picb (IO_BASE + picb_physaddr)

