Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbZLCUR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbZLCUR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZLCUR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:17:57 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:60315 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZLCUR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:17:56 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 3 Dec 2009 13:17:38 -0700
X-Google-Sender-Auth: 438c0eaf83288b5e
Message-ID: <fa686aa40912031217s5ac169ecs4130d650a49ad2b1@mail.gmail.com>
Subject: [git pull] OF device tree rework for 2.6.33
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Michal Simek <michal.simek@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is my first batch of rework commits for the OF device tree
support code.  This is the first time I'm getting you to pull directly
and it involves cross architecture code (SPARC, ppc & microblaze), so
I'm starting with a small batch of the changes to avoid stupid
breakage.  Everything is signed off correctly, and sfr has been
pulling it into linux-next for some weeks now.

Let me know if you need me to change anything.

The following changes since commit 22763c5cf3690a681551162c15d34d935308c8d7:
  Linus Torvalds (1):
        Linux 2.6.32

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 next-devicetree

Grant Likely (12):
      of: Rework linux/of.h and asm/prom.h include ordering
      of: merge phandle, ihandle and struct property
      of: merge struct device_node
      of: Move OF_IS_DYNAMIC and OF_MARK_DYNAMIC macros to of.h
      of: add common header for flattened device tree representation
      of: merge struct boot_param_header from Microblaze and PowerPC
      of: merge of_node_*_flag() and set_node_proc_entry()
      of: merge of_read_number() an of_read_ulong()
      of: merge of_node_get(), of_node_put() and of_find_all_nodes()
      of: merge of_*_flat_dt*() functions
      of: merge other miscellaneous prototypes
      of: merge of_find_all_nodes() implementations

 arch/microblaze/include/asm/prom.h |  135 +--------------------------------
 arch/microblaze/kernel/head.S      |    2 +-
 arch/microblaze/kernel/prom.c      |   23 ------
 arch/powerpc/include/asm/prom.h    |  147 +-----------------------------------
 arch/powerpc/kernel/prom.c         |   23 ------
 arch/sparc/include/asm/prom.h      |   55 +-------------
 drivers/of/base.c                  |   26 ++++++-
 include/linux/of.h                 |  103 +++++++++++++++++++++++++
 include/linux/of_fdt.h             |   86 +++++++++++++++++++++
 9 files changed, 221 insertions(+), 379 deletions(-)
 create mode 100644 include/linux/of_fdt.h


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
