Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbYHSNtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbYHSNtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756428AbYHSNsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:48:14 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39717 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418AbYHSNsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:48:13 -0400
Date: Tue, 19 Aug 2008 16:48:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, Brice Goglin <brice@myri.com>,
       netdev@vger.kernel.org
Subject: frv must provide ioremap_wc
Message-ID: <20080819134801.GI8852@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<--  snip  -->

...
  CC      drivers/net/myri10ge/myri10ge.o
myri10ge.c: In function 'myri10ge_probe':
myri10ge.c:3725: error: implicit declaration of function 'ioremap_wc'
...
make[4]: *** [drivers/net/myri10ge/myri10ge.o] Error 1

<--  snip  -->

http://kerneltrap.org/mailarchive/linux-netdev/2008/8/11/2889824/thread 
contains a discussion of the same problem on ARM.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

