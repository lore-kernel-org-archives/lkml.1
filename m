Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbYFFQW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbYFFQW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbYFFQWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:22:46 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46656 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYFFQWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:22:45 -0400
Date: Fri, 6 Jun 2008 19:22:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Graf Yang <graf.yang@analog.com>, Bryan Wu <cooloney@kernel.org>,
       sonic.zhang@analog.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: serial/bfin_5xx.c build error
Message-ID: <20080606162203.GB2201@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7d01b475ab17018756c8df27c2ee3c220fab05f8
(Blackfin Serial Driver: Enable IR function when user application)
causes the following build error:

<--  snip  -->

...
  CC      drivers/serial/bfin_5xx.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c: In function 'bfin_serial_init':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c:1209: error: 'struct tty_driver' has no member named 'set_ldisc'
make[3]: *** [drivers/serial/bfin_5xx.o] Error 1

<--  snip  -->

In case it can't be fixed quickly a revert might be an option for 2.6.26.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

