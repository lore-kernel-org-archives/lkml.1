Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbXIPRYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbXIPRYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 13:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbXIPRX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 13:23:58 -0400
Received: from postfix1-g20.free.fr ([212.27.60.42]:54939 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbXIPRX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 13:23:58 -0400
Date: Sun, 16 Sep 2007 19:26:38 +0200
From: FD Cami <francois.cami@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: scheduler improvements : 2.6.21 vs 2.6.22-ck1 vs 2.6.23-rc6
Message-Id: <20070916192638.c010a4fd.francois.cami@free.fr>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Warning: I have not run any benchmarks. One thing I am (more or less)
able to measure is my own ability to headshot in some games like UT99.
The other thing is to see if flash videos stutter or die under load.
Please remember, this is about desktop usage - not numbers. 

my computer:
PIII-S 1400 (512KB L2)
TUSL2-C (i815ep)
512MB PC133
FireGL 8800 (~Radeon 8500 128MB) with dri drivers


Hello Ingo, LKML,

Here are the results of a few informal tests (flash videos, playing
UT99, and looping kernel compilation in background).

* 2.6.21.5 is OK but interactivity is not good (i.e. I sometimes
  get "lag" under load).

* 2.6.22-ck1 is better, interactivity-wise, but becomes unusable under
  load (i.e. a kernel compilation + desktop switch breaks flash
  videos ; UT99 is too slow when compiling too).

* 2.6.23-rc6 is... perfect, as good as can be on my old PC. Flash never
  breaks even on high I/O or compilation load (within reasonable
  limits). Gaming is great, which wasn't the case before.

Thanks for the good work.

Best,

François
