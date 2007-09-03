Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbXICKq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbXICKq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbXICKqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:46:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34020 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753891AbXICKqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:46:18 -0400
Date: Mon, 3 Sep 2007 12:46:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jeff Dike <jdike@linux.intel.com>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jan Dittmer <jdi@l4x.org>
Subject: 2.6.23-rc5 regression: uml on x86_64 compile error
Message-ID: <20070903104619.GR16016@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d1254b12c93e1e586137a2ffef71fd33cf273f35 causes the following 
compile error (found at [1]):

<--  snip  -->

...
CC      fs/binfmt_elf.o
In file included from fs/binfmt_elf.c:30:
include/linux/elfcore.h: In function ‘elf_core_copy_regs’:
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
include/linux/elfcore.h:103: error: ‘union uml_pt_regs’ has no member named ‘gp’
make[2]: *** [fs/binfmt_elf.o] Error 1

<--  snip  -->

cu
Adrian

[1] http://l4x.org/k/?d=33926#err

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

