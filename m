Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZLAO5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZLAO5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZLAO5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:57:13 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:43363 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZLAO5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:57:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=bD0cYtgEw8uj5eEyVaUMsfJFcNE5mCq9VKYvOI2fkvewEpfjR2OEfwyq8UDWn2EIuk
         i7OteEB/gBG2i0hse4HeVFi2aE6sKdT1540pTeNd1ggolGHzRLWsJ7179S973dX+4pfY
         NeCSmy16LxlO9PT8z+3FAxNNSs5H/pJcfW6zs=
MIME-Version: 1.0
Date: Tue, 1 Dec 2009 09:57:15 -0500
Message-ID: <b4198de60912010657j6e6e68fcu461269fae9a9a198@mail.gmail.com>
Subject: [PULL] alpha-2.6
From: Matt Turner <mattst88@gmail.com>
To: torvalds@linux-foundation.org
Cc: LKML <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the 'for-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6.git
for-linus

It contains a couple _trivial_ changes and a regression fix from the
new alpha-2.6.git tree. The pull request was sent so late in the cycle
because the tree was only created yesterday. The patches have been
floating around for a much longer time though. :)

This is my first pull request, so please let me know if there's
anything I should do differently in the future.

Thanks,
Matt Turner


The following changes since commit a8a8a669ea13d792296737505adc43ccacf3a648:
  Linus Torvalds (1):
        Merge branch 'i2c-pnx-fixes' of git://git.fluff.org/bjdooks/linux

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6.git for-linus

Julia Lawall (2):
      arch/alpha/kernel/sys_ruffian.c: Use DIV_ROUND_CLOSEST
      arch/alpha/kernel: Add kmalloc NULL tests

Michael Cree (1):
      Alpha: Rearrange thread info flags fixing two regressions

Thomas Gleixner (1):
      alpha: Fixup last users of irq_chip->typename

 arch/alpha/include/asm/thread_info.h |   27 +++++++++++++++------------
 arch/alpha/kernel/core_marvel.c      |    2 ++
 arch/alpha/kernel/core_titan.c       |    2 ++
 arch/alpha/kernel/irq.c              |    2 +-
 arch/alpha/kernel/irq_alpha.c        |    2 +-
 arch/alpha/kernel/irq_i8259.c        |    2 +-
 arch/alpha/kernel/irq_pyxis.c        |    2 +-
 arch/alpha/kernel/irq_srm.c          |    2 +-
 arch/alpha/kernel/sys_alcor.c        |    2 +-
 arch/alpha/kernel/sys_cabriolet.c    |    2 +-
 arch/alpha/kernel/sys_dp264.c        |    4 ++--
 arch/alpha/kernel/sys_eb64p.c        |    2 +-
 arch/alpha/kernel/sys_eiger.c        |    2 +-
 arch/alpha/kernel/sys_jensen.c       |    2 +-
 arch/alpha/kernel/sys_marvel.c       |    6 +++---
 arch/alpha/kernel/sys_mikasa.c       |    2 +-
 arch/alpha/kernel/sys_noritake.c     |    2 +-
 arch/alpha/kernel/sys_rawhide.c      |    2 +-
 arch/alpha/kernel/sys_ruffian.c      |    2 +-
 arch/alpha/kernel/sys_rx164.c        |    2 +-
 arch/alpha/kernel/sys_sable.c        |    2 +-
 arch/alpha/kernel/sys_takara.c       |    2 +-
 arch/alpha/kernel/sys_titan.c        |    2 +-
 arch/alpha/kernel/sys_wildfire.c     |    2 +-
 24 files changed, 43 insertions(+), 36 deletions(-)
