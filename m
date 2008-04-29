Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbYD2S17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbYD2S17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbYD2S1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:27:49 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52745 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbYD2S1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:27:49 -0400
Date: Tue, 29 Apr 2008 21:27:10 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Denis V. Lunev" <den@openvz.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: pcmcia_ioctl.c compile error
Message-ID: <20080429182709.GB2898@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9c37066d888bf6e1b96ad12304971b3ddeabbad0 (proc: remove proc_bus) 
came through -mm that contains a patch implementing the overdue removal 
of the PCMCIA control ioctl that did not yet make it into Linus' tree:

<---  snip  -->

...
  CC      drivers/pcmcia/pcmcia_ioctl.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pcmcia/pcmcia_ioctl.c: In function ‘pcmcia_setup_ioctl’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pcmcia/pcmcia_ioctl.c:790: error: ‘proc_bus’ undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pcmcia/pcmcia_ioctl.c:790: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pcmcia/pcmcia_ioctl.c:790: error: for each function it appears in.)
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pcmcia/pcmcia_ioctl.c: In function ‘pcmcia_cleanup_ioctl’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pcmcia/pcmcia_ioctl.c:801: error: ‘proc_bus’ undeclared (first use in this function)
make[3]: *** [drivers/pcmcia/pcmcia_ioctl.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

