Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbZJLAdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbZJLAdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 20:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZJLAdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 20:33:50 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:50462 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbZJLAdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 20:33:50 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Oct 2009 20:33:50 EDT
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200910120026.n9C0QdSe019248@clem.clem-digital.net>
Subject: 2.6.32-rc4 fail compile -- drivers/char/rtc.c
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Sun, 11 Oct 2009 20:26:39 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi:
(i386 SMP)


  CC      drivers/char/rtc.o
drivers/char/rtc.c: In function 'rtc_interrupt':
drivers/char/rtc.c:271: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
drivers/char/rtc.c:271: error: (Each undeclared identifier is reported only once
drivers/char/rtc.c:271: error: for each function it appears in.)
drivers/char/rtc.c:273: error: 'SIGIO' undeclared (first use in this function)
drivers/char/rtc.c:273: error: 'POLL_IN' undeclared (first use in this function)
drivers/char/rtc.c: In function 'rtc_read':
drivers/char/rtc.c:362: error: implicit declaration of function '__set_current_state'
drivers/char/rtc.c:362: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
drivers/char/rtc.c:376: error: implicit declaration of function 'signal_pending'
drivers/char/rtc.c:380: error: implicit declaration of function 'schedule'
drivers/char/rtc.c:393: error: 'TASK_RUNNING' undeclared (first use in this function)
drivers/char/rtc.c: In function 'rtc_dropped_irq':
drivers/char/rtc.c:1206: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
drivers/char/rtc.c:1208: error: 'SIGIO' undeclared (first use in this function)
drivers/char/rtc.c:1208: error: 'POLL_IN' undeclared (first use in this function)
make[2]: *** [drivers/char/rtc.o] Error 1
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2

-- 
Pete Clements 
