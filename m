Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbYHBSRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbYHBSRl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 14:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbYHBSRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 14:17:33 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55998 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbYHBSRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 14:17:32 -0400
Date: Sat, 2 Aug 2008 21:16:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: cooloney@kernel.org, sonic.zhang@analog.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: serial/bfin_5xx.c build error
Message-ID: <20080802181624.GQ19682@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems to be broken by Alan's changes:

<--  snip  -->

...
  CC      drivers/serial/bfin_5xx.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c: In function 'bfin_serial_set_ldisc':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c:820: error: 'struct tty_ldisc' has no member named 'num'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c: In function 'bfin_serial_console_write':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c:1001: warning: comparison of distinct pointer types lacks a cast
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c:1003: warning: comparison of distinct pointer types lacks a cast
make[3]: *** [drivers/serial/bfin_5xx.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

