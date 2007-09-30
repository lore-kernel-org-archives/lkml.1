Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbXI3Imb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbXI3Imb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 04:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbXI3ImX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 04:42:23 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:48104 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381AbXI3ImX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 04:42:23 -0400
Date: Sun, 30 Sep 2007 11:42:20 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>, sam@ravnborg.org
Subject: another gcc-4.2 compile problem on alpha: gameport
Message-ID: <Pine.SOC.4.64.0709301140060.6443@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After I applied the psmouse-base section fix (thanks!), I wuickly ran 
into another compile problem with gcc-4.2 on alpha:

  CC [M]  drivers/input/gameport/gameport.o
drivers/input/gameport/gameport.c:42: error: __ksymtab_gameport_set_name causes a section type conflict
drivers/input/gameport/gameport.c:41: error: __ksymtab_gameport_cooked_read causes a section type conflict

-- 
Meelis Roos (mroos@linux.ee)
