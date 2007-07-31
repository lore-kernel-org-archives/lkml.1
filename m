Return-Path: <linux-kernel-owner+w=401wt.eu-S934233AbXGaUg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934233AbXGaUg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933334AbXGaUgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:36:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:31400 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933984AbXGaUgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:36:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=YlDgp0tIWsKcaRmJ1A3JW28ZokPdnQUtBJB5kiCIT21Jpki9YUuqqQzBuza/R6sNyPzYSd0bOKz1rhAAKW/2zt6tdExjFPdR0oWfblgPJghbiSDAFyTlBzKsOeo43wfOz4vAMGdLsnGgI414OGSw024guirygFlPpUhWmXAK5OM=
Message-ID: <46AF9D3F.3020603@googlemail.com>
Date: Tue, 31 Jul 2007 22:36:15 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Use correct config option in arch/i386/kernel/alternative.c
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

File /home/devel/linux-rdc/arch/i386/kernel/alternative.c line 382
Unknown CONFIG option! CONFIG_MCE
File /home/devel/linux-rdc/arch/i386/kernel/alternative.c line 420
Unknown CONFIG option! CONFIG_MCE

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-rdc-clean/arch/i386/kernel/alternative.c	2007-07-31 17:17:34.000000000 +0200
+++ linux-rdc/arch/i386/kernel/alternative.c	2007-07-31 18:52:07.000000000 +0200
@@ -379,7 +379,7 @@ void __init alternative_instructions(voi
 	   that might execute the to be patched code.
 	   Other CPUs are not running. */
 	stop_nmi();
-#ifdef CONFIG_MCE
+#ifdef CONFIG_X86_MCE
 	stop_mce();
 #endif
 
@@ -417,7 +417,7 @@ void __init alternative_instructions(voi
 	local_irq_restore(flags);
 
 	restart_nmi();
-#ifdef CONFIG_MCE
+#ifdef CONFIG_X86_MCE
 	restart_mce();
 #endif
 }
