Return-Path: <linux-kernel-owner+w=401wt.eu-S1161225AbXBUNZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161225AbXBUNZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161227AbXBUNZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:25:49 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:59571 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161225AbXBUNZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:25:48 -0500
From: Faik Uygur <faik@pardus.org.tr>
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc1
Date: Wed, 21 Feb 2007 15:26:40 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jirislaby@gmail.com
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702211526.41493.faik@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

21 Şub 2007 Çar 06:53 tarihinde, Linus Torvalds şunları yazmıştı: 
> Ok, the merge window for 2.6.21 has closed, and -rc1 is out there.

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CHK     include/linux/compile.h
  CC [M]  drivers/char/ip2/ip2main.o
In file included from drivers/char/ip2/ip2main.c:285:
drivers/char/ip2/i2lib.c: In function `iiSendPendingMail_t':
drivers/char/ip2/i2lib.c:83: sorry, unimplemented: inlining failed in call 
to 'iiSendPendingMail': function body not available
drivers/char/ip2/i2lib.c:157: sorry, unimplemented: called from here
make[3]: *** [drivers/char/ip2/ip2main.o] Error 1
make[2]: *** [drivers/char/ip2] Error 2
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2

With cleanup changes in commit 40565f1962c5be9b9e285e05af01ab7771534868 
compilation fails.

Regards,
- Faik
