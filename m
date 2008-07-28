Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbYG1UVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbYG1UVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYG1UU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:20:56 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:44890 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547AbYG1UUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:20:55 -0400
Date: Mon, 28 Jul 2008 23:20:12 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Adrian McMenamin <adrian@mcmen.demon.co.uk>,
       Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: drivers/sh/maple/maple.c compile error
Message-ID: <20080728202012.GD7713@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 306cfd630a4d121cf4e08b894d8b4c4cf106e57e
(maple: tidy maple_driver code by removing redundant connect/disconnect)
causes the following compile error:

<--  snip  -->

...
  CC      drivers/sh/maple/maple.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c: In function 'attach_matching_maple_driver':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c:259: error: 'struct maple_driver' has no member named 'connect'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c: In function 'maple_detach_driver':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c:272: error: 'struct maple_driver' has no member named 'disconnect'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c:273: error: 'struct maple_driver' has no member named 'disconnect'
make[4]: *** [drivers/sh/maple/maple.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

