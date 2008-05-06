Return-Path: <linux-kernel-owner+w=401wt.eu-S1760905AbYEFNsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbYEFNsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757143AbYEFNsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:48:00 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36263 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944AbYEFNr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:47:59 -0400
Date: Tue, 6 May 2008 16:46:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, kyle@parisc-linux.org,
       matthew@wil.cx, grundler@parisc-linux.org
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: parisc DISCONTIGMEM compile breakage
Message-ID: <20080506134648.GA30082@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 54a6eb5c4765aa573a030ceeba2c14e3d2ea5706
(mm: use two zonelist that are filtered by GFP mask)
causes the following build error with CONFIG_DISCONTIGMEM=y
on parisc:

<--  snip  -->

...
  CC      arch/parisc/mm/init.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/parisc/mm/init.c: In function 'show_mem':
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/parisc/mm/init.c:609: error: too few arguments to function 'node_zonelist'
make[2]: *** [arch/parisc/mm/init.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

