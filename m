Return-Path: <linux-kernel-owner+w=401wt.eu-S1765060AbXHAT0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765060AbXHAT0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 15:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbXHAT0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 15:26:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52938 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbXHAT0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 15:26:11 -0400
Date: Wed, 1 Aug 2007 21:26:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andi Kleen <ak@novell.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Deprecate a.out ELF interpreters
In-Reply-To: <200708012035.52863.ak@novell.com>
Message-ID: <Pine.LNX.4.64.0708012125290.26668@fbirervta.pbzchgretzou.qr>
References: <200708011433.09433.ak@novell.com>
 <Pine.LNX.4.64.0708012029130.26668@fbirervta.pbzchgretzou.qr>
 <200708012035.52863.ak@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 1 2007 20:35, Andi Kleen wrote:
>> On Aug 1 2007 14:33, Andi Kleen wrote:
>> >Comments?
>> 
>> A kconfig entry "(OBSOLETE)"/"(DEPRECATED)" would be nice.
>> (And if you want to test people, 'depends on EMBEDDED' for CONFIG_BINFMT_AOUT)
>
>The point is to have less clutter in binfmt_elf.c (which really
>could need a rewrite btw or at least a lot of cleanup) not add more in form 
>of ifdefs.


---
 fs/Kconfig.binfmt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/fs/Kconfig.binfmt
===================================================================
--- linux-2.6.23.orig/fs/Kconfig.binfmt
+++ linux-2.6.23/fs/Kconfig.binfmt
@@ -56,7 +56,7 @@ config BINFMT_SHARED_FLAT
 	  Support FLAT shared libraries
 
 config BINFMT_AOUT
-	tristate "Kernel support for a.out and ECOFF binaries"
+	tristate "Kernel support for a.out and ECOFF binaries (OBSOLETE)"
 	depends on X86_32 || ALPHA || ARM || M68K || SPARC32
 	---help---
 	  A.out (Assembler.OUTput) is a set of formats for libraries and



Plusminus "depends on EMBEDDED" to already hide it in the short term until
removal. (Yes, ideally, one would use the yet-to-be-introduced CONFIG_OBSOLETE)

	Jan
-- 
