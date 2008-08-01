Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbYHAVp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbYHAVp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbYHAVpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:45:44 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42402 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758789AbYHAVpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:45:42 -0400
Date: Sat, 2 Aug 2008 00:44:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: starvik@axis.com, jesper.nilsson@axis.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dev-etrax@axis.com, linux-kernel@vger.kernel.org
Subject: drivers/serial/crisv10.c build error
Message-ID: <20080801214439.GG19682@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Broken to be broken by Alan's changes:

<--  snip  -->

...
  CC      drivers/serial/crisv10.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'update_char_time':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:971: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'rs_stop':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:1486: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'add_char_and_flag':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:1776: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'receive_chars_dma':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:1876: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'flush_to_flip_buffer':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2126: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'handle_ser_rx_interrupt_no_dma':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2291: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2354: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2400: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'handle_ser_tx_interrupt':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2551: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2552: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2565: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2566: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'do_softint':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2730: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'startup':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2830: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2831: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'shutdown':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2945: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2945: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2951: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2952: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'change_speed':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2969: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2969: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:2974: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:3102: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:3104: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'set_serial_info':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:3481: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'rs_close':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:3817: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'rs_hangup':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:3921: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'rs_open':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:4083: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:4085: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'line_info':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:4273: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:4275: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:4277: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:4278: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:4280: error: request for member 'tty' in something not a structure or union
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: At top level:
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:4388: warning: initialization from incompatible pointer type
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c: In function 'rs_init':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/crisv10.c:4471: error: request for member 'tty' in something not a structure or union
make[3]: *** [drivers/serial/crisv10.o] Error 1
make[2]: *** [drivers/serial] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

