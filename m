Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYBQULP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYBQULP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYBQUKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:10:20 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53474 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbYBQUKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:10:11 -0500
Date: Sun, 17 Feb 2008 22:09:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Dmitry Torokhov <dtor@mail.ru>, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: cdev removal broke cobalt_btns.c compilation
Message-ID: <20080217200942.GF1403@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0c1efd365306c9b04df5abdd41e9b4dc721e84fb broke the compilation of 
cobalt_btns.c:

<--  snip  -->

...
  CC      drivers/input/misc/cobalt_btns.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/misc/cobalt_btns.c: In function 'cobalt_buttons_probe':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/misc/cobalt_btns.c:100: error: 'struct input_dev' has no member named 'cdev'
...
make[4]: *** [drivers/input/misc/cobalt_btns.o] Error 1
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

