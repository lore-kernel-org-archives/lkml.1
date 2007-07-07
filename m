Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbXGGUOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbXGGUOR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 16:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbXGGUOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 16:14:09 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53784 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752547AbXGGUOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 16:14:07 -0400
Date: Sat, 7 Jul 2007 22:14:37 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: 2.6.22 regression: h8300 generic irq compile error
Message-ID: <20070707201437.GK3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c728d60455e8e8722ee08312a75f38dd7a866b5e causes the following 
compile error:

<--  snip  -->

...
  AS      arch/h8300/platform/h8300h/entry.o
make[2]: *** No rule to make target `arch/h8300/platform/h8300h/irq_pin.o', needed by `arch/h8300/platform/h8300h/built-in.o'.  Stop.
make[1]: *** [arch/h8300/platform/h8300h] Error 2

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

