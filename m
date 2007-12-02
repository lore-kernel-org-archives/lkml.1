Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbXLBAmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbXLBAmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 19:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbXLBAmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 19:42:13 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60144 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753033AbXLBAmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 19:42:12 -0500
Date: Sun, 2 Dec 2007 01:42:04 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: linux-kernel@vger.kernel.org
Subject: blackfin compile error
Message-ID: <20071202004204.GE15974@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems commit 5d448dd50712ae42f8176b5bb8db4703bef6f0f5 was incomplete:

<--  snip  -->

...
  CC      arch/blackfin/mach-bf537/boards/stamp.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: error: unknown field 'pin_req' specified in initializer
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: error: extra brace group at end of initializer
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: error: (near initialization for 'bfin_spi0_info')
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: warning: excess elements in struct initializer
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: warning: (near initialization for 'bfin_spi0_info')
make[2]: *** [arch/blackfin/mach-bf537/boards/stamp.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

