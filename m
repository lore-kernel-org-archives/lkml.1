Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbYBMS51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbYBMS51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYBMS5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:57:19 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:45900 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbYBMS5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:57:18 -0500
Date: Wed, 13 Feb 2008 20:57:03 +0200
From: Adrian Bunk <bunk@kernel.org>
To: starvik@axis.com, jesper.nilsson@axis.com
Cc: dev-etrax@axis.com, linux-kernel@vger.kernel.org
Subject: cris/arch-v10/lib/memset.c compile error
Message-ID: <20080213185703.GC14269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to compile a cris defconfig with an svn gcc (that will become
gcc 4.3) fails with the following error:

<--  snip  -->

...
  CC      arch/cris/arch-v10/lib/memset.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c: In function 'memset':
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:164: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:165: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:166: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:167: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:185: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:189: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:192: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:196: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:200: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:201: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:205: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:206: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:209: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:210: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:214: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:215: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:219: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:220: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:221: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:225: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:226: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:227: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:230: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:231: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:232: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:236: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:237: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:238: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:242: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:243: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:244: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:245: error: lvalue required as increment operand
make[2]: *** [arch/cris/arch-v10/lib/memset.o] Error 1
make[1]: *** [arch/cris/arch-v10/lib] Error 2
make: *** [sub-make] Error 2

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

