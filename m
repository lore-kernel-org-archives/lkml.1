Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbYJLMTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbYJLMTZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 08:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbYJLMTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 08:19:05 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51297 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbYJLMTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 08:19:04 -0400
Date: Sun, 12 Oct 2008 15:18:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: mips ip27_defconfig defconfig build error
Message-ID: <20081012121805.GG31153@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2a31b03335e570dce5fdd082e0d71d48b2cb4290
(MIPS: Rewrite spinlocks to ticket locks.) causes
the following build error with ip27_defconfig:

<--  snip  -->

...
  CC      arch/mips/kernel/module.o
{standard input}: Assembler messages:
{standard input}:1405: Error: local label `"2" (instance number 1 of a fb label)' is not defined
make[2]: *** [arch/mips/kernel/module.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


