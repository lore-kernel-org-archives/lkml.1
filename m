Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbYHEQIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbYHEQIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYHEQIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:08:25 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41526 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbYHEQIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:08:24 -0400
Date: Tue, 5 Aug 2008 18:44:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: rsk7203_defconfig build error
Message-ID: <20080805154429.GD22895@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

rsk7203_defconfig fails to build with the following error:

<--  snip  -->

...
  LD      .tmp_vmlinux1
arch/sh/kernel/built-in.o:(__ksymtab+0xb8): undefined reference to `__udivsi3_i4i'
arch/sh/kernel/built-in.o:(__ksymtab+0xc8): undefined reference to `__sdivsi3_i4i'
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

That worked with 2.6.26, and these are far less undefined references 
than in the cases where libgcc was missing.

Does it build with your toolchain?
Do you have any clue what's going wrong here?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

