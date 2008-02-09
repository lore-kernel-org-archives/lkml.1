Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbYBIAPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbYBIAPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYBIAO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:14:59 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38378 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbYBIAO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:14:59 -0500
Date: Sat, 9 Feb 2008 02:15:15 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, rmk@arm.linux.org.uk
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: ide/arm/bast-ide.c compile error
Message-ID: <20080209001515.GF6505@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9e016a719209d95338e314b46c3012cc7feaaeec causes the following 
compile error:

<--  snip  -->

...
  CC      drivers/ide/arm/bast-ide.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/arm/bast-ide.c: In function 'bastide_register':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/arm/bast-ide.c:31: error: 'hwif' redeclared as different kind of symbol
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/arm/bast-ide.c:29: error: previous definition of 'hwif' was here
make[4]: *** [drivers/ide/arm/bast-ide.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

