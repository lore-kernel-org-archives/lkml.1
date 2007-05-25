Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbXEYH1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbXEYH1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759394AbXEYH1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:27:09 -0400
Received: from nibbel.kulnet.kuleuven.ac.be ([134.58.240.41]:35575 "EHLO
	nibbel.kulnet.kuleuven.ac.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565AbXEYH1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:27:08 -0400
X-Greylist: delayed 1956 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 03:27:08 EDT
Message-ID: <46568824.1020904@joow.be>
Date: Fri, 25 May 2007 08:54:28 +0200
From: Pieter Palmers <pieterp@joow.be>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [Fwd: [FFADO-devel] rt patches error]
Content-Type: multipart/mixed;
 boundary="------------050807030708070102000701"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050807030708070102000701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

FYI

-------- Original Message --------

Hi people

patch-2.6.21-rt7 contains error that make kernel compilation
impossible. Since I dont know what to do, I'm sending fix for here.
Maybe somebody can send for correct place (Ingo page don't have
information about contact).

Regards,
-- 
Marcio Roberto Teixeira

skype: marcio.tex
http://marciotex.googlepages.com/

chave pública:
hkp://wwwkeys.pgp.net
http://marciotex.googlepages.com/keypub_8709626B.asc

Usuário "tchê" Debian/GNU Linux

Porto Alegre - RS - Brasil




--------------050807030708070102000701
Content-Type: text/x-patch;
 name="fixing_patch-2.6.21-rt7.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fixing_patch-2.6.21-rt7.patch"

--- patch-2.6.21-rt7.orig	2007-05-24 23:22:42.000000000 -0300
+++ patch-2.6.21-rt7	2007-05-24 23:30:20.000000000 -0300
@@ -13931,7 +13931,7 @@
 +	S_WAITING_FOR_READ,	/* Signal delivered. waiting for rtc_read() */
 +	S_READ_MISSED,		/* Signal delivered, read() deadline missed */
 +};
-+
++#endif
  #endif
  
  #ifdef	CONFIG_HPET_RTC_IRQ

--------------050807030708070102000701--
