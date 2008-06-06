Return-Path: <linux-kernel-owner+w=401wt.eu-S1764006AbYFFQXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764006AbYFFQXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761670AbYFFQWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:22:55 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36000 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760982AbYFFQWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:22:53 -0400
Date: Fri, 6 Jun 2008 19:22:12 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bryan Wu <cooloney@kernel.org>, Jeff Garzik <jeff@garzik.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: blackfin drivers/net/smc91x.c build error
Message-ID: <20080606162212.GC2201@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/smc91x.c fails as follows on blackfin:

<--  snip  -->

...
  CC      drivers/net/smc91x.o
...
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/smc91x.c:1863:36: error: macro "SMC_GET_MAC_ADDR" passed 2 arguments, but takes just 1
...
make[3]: *** [drivers/net/smc91x.o] Error 1

<--  snip  -->

The required action seems to be a revert of:
commit 099c736a470c8080a166e7a089f1e48e15f9947c
(Revert "smc91x: fix build breakage from the SMC_GET_MAC_ADDR API upgrade") (sic).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

