Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYBQUKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYBQUKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYBQUKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:10:06 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59621 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbYBQUKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:10:04 -0500
Date: Sun, 17 Feb 2008 22:09:35 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Dmitry Torokhov <dtor@mail.ru>, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: cobalt_btns.c <-> struct platform_device compile error
Message-ID: <20080217200935.GE1403@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b037b08e59633d939d79f1df9c43c6625f8db904 broke the compilation of 
cobalt_btns.c:

<--  snip  -->

...
  CC      drivers/input/misc/cobalt_btns.o
...
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/misc/cobalt_btns.c: In function 'cobalt_buttons_probe':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/misc/cobalt_btns.c:101: error: 'struct platform_device' has no member named 'keymap'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/misc/cobalt_btns.c:102: error: 'struct platform_device' has no member named 'keymap'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/misc/cobalt_btns.c:102: error: 'struct platform_device' has no member named 'keymap'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/misc/cobalt_btns.c:102: error: 'struct platform_device' has no member named 'keymap'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/misc/cobalt_btns.c:102: error: 'struct platform_device' has no member named 'keymap'
...
make[4]: *** [drivers/input/misc/cobalt_btns.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

