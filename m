Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbYBPJ6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbYBPJ6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 04:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYBPJ6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 04:58:17 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:48442 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbYBPJ6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 04:58:16 -0500
Date: Sat, 16 Feb 2008 11:57:39 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>, starvik@axis.com
Cc: dev-etrax@axis.com, linux-kernel@vger.kernel.org
Subject: cris/arch-v10/lib/string.c compile error
Message-ID: <20080216095739.GE9962@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next file, same problem:

<--  snip  -->

...
  CC      arch/cris/arch-v10/lib/string.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/string.c:138: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/string.c:138: error: lvalue required as increment operand
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/string.c:139: error: lvalue required as increment operand
...

<--  snip  -->

And looking at Jan Dittmer's page [1] that problem is not limited to the 
SVN head gcc I'm using since he's running into the same error with
gcc 4.0.4.

Can you try compiling a cris kernel with a gcc 4 based toolchain?

cu
Adrian

[1] http://l4x.org/k/?d=38964

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

