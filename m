Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbXKYKlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbXKYKlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 05:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXKYKlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 05:41:11 -0500
Received: from smtp105.plus.mail.re1.yahoo.com ([69.147.102.68]:36038 "HELO
	smtp105.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750918AbXKYKlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 05:41:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=estYWtTyazZmcCmMUdHw6bdgwOtiiy6+pb68yiT7U9x4hYBR8ZZpkWxGZp+bymbejcHOOK5NJ0KypLycf+A3xOqFgEbzgyRSKzymVA8ZRMWC5Ej35nQy0hQcKH7+febA4igHPnMsGiJZ/3I1zbiPp+a6ffwls1OJ1p6QizWI7l4=  ;
X-YMail-OSG: ejoK.asVM1lL2sM.6Ok6ugDdjxmqM056Ry1JmifQIBzQTz_3dbO98GwGeW69aJeNcjk44KKnsQ--
Date: Sun, 25 Nov 2007 11:27:11 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] vmlinux_32.lds.S: remove repeated comment from the x86-32
	linker script
Message-ID: <20071125102711.GA16310@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Remove repeated comment from the linker script for the x86-32 target.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--

 arch/x86/kernel/vmlinux_32.lds.S |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 7d72cce..39252d4 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -3,22 +3,16 @@
  *
  * Don't define absolute symbols until and unless you know that symbol
  * value is should remain constant even if kernel image is relocated
  * at run time. Absolute symbols are not relocated. If symbol value should
  * change if kernel is relocated, make the symbol section relative and
  * put it inside the section definition.
  */
 
-/* Don't define absolute symbols until and unless you know that symbol
- * value is should remain constant even if kernel image is relocated
- * at run time. Absolute symbols are not relocated. If symbol value should
- * change if kernel is relocated, make the symbol section relative and
- * put it inside the section definition.
- */
 #define LOAD_OFFSET __PAGE_OFFSET
 
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/thread_info.h>
 #include <asm/page.h>
 #include <asm/cache.h>
 #include <asm/boot.h>
 
-- 
Regards/Gruﬂ,
    Boris.
