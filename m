Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbXJ2OWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbXJ2OWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbXJ2OW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:22:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:53597 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbXJ2OW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:22:27 -0400
From: Stefan Roese <stefan.roese@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Bootup support for watchdog with short timeout (touch_nmi_watchdog()?)
Date: Mon, 29 Oct 2007 15:22:27 +0100
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 966
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200710291522.27311.stefan.roese@gmail.com>
X-Provags-ID: V01U2FsdGVkX1+EvjyMbN+0VDotsRGf+/MK+G7+qm5GpUlkNM5
 qitz5rOS0ZpJLELi7JZrWR/1XC7W5CsfXv6tT6O0nQcg0nilI7
 MxcQf2f9ZXPL2awAoVieaLei1hBgPGg
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to implement support for a board specific watchdog on a PPC440EPx 
board with a very short timeout. In this case, the watchdog has to 
be "kicked" at least every 100ms, even while booting and the real watchdog 
driver not running yet. While looking for trigger places in the kernel 
source, I noticed the already existing "touch_nmi_watchdog()" function, which 
seems to be doing what I need. Even if the name not exactly matches my 
hardware setup.

My question now is, is it recommended to use this 
touch_nmi_watchdog() "infrastructure" for my PPC custom specific watchdog 
during bootup? And if yes, should it perhaps be renamed to a more generic 
name, like "touch_watchdog"?

Please advise. Thanks.

Best regards,
Stefan
