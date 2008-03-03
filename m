Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbYCCPka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbYCCPka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYCCPkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:40:21 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42697 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618AbYCCPkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:40:19 -0500
Date: Mon, 3 Mar 2008 17:38:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sh sh7710voipgw_defconfig compile error
Message-ID: <20080303153843.GD26072@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems commit 9a7ef6d59f9d4780ff5bc9c4d05266b52dcb9211 broke the 
support for this board:

<--  snip  -->

...
  CC      arch/sh/boards/renesas/sh7710voipgw/setup.o
arch/sh/boards/renesas/sh7710voipgw/setup.c:15: error: array type has incomplete element type
arch/sh/boards/renesas/sh7710voipgw/setup.c:16: error: 'TIMER2_IRQ' undeclared here (not in a function)
arch/sh/boards/renesas/sh7710voipgw/setup.c:16: error: 'TIMER2_IPR_ADDR' undeclared here (not in a function)
arch/sh/boards/renesas/sh7710voipgw/setup.c:16: error: 'TIMER2_IPR_POS' undeclared here (not in a function)
arch/sh/boards/renesas/sh7710voipgw/setup.c:16: error: 'TIMER2_PRIORITY' undeclared here (not in a function)
arch/sh/boards/renesas/sh7710voipgw/setup.c:17: error: 'WDT_IRQ' undeclared here (not in a function)
arch/sh/boards/renesas/sh7710voipgw/setup.c:17: error: 'WDT_IPR_ADDR' undeclared here (not in a function)
arch/sh/boards/renesas/sh7710voipgw/setup.c:17: error: 'WDT_IPR_POS' undeclared here (not in a function)
arch/sh/boards/renesas/sh7710voipgw/setup.c:17: error: 'WDT_PRIORITY' undeclared here (not in a function)
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

