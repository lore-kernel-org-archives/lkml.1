Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYBPKrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYBPKrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 05:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYBPKrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 05:47:12 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41681 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbYBPKrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 05:47:11 -0500
Date: Sat, 16 Feb 2008 12:46:49 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: git-xtensa doesn't like my cross compiler
Message-ID: <20080216104648.GH9962@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With git-xtensa I'm getting:

<--  snip  -->

...
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/xtensa/Makefile:30: *** No Xtensa toolchain found on PATH..  Stop.
make: *** [sub-make] Error 2

<--  snip  -->

My xtensa cross toolchain is prefixed xtensa-linux- and 
arch/xtensa/Makefile shouldn't make any assumptions regarding how the 
cross compiler is named.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

