Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbZKRB5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbZKRB5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZKRB5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:57:52 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39298 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbZKRB5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:57:52 -0500
Date: Wed, 18 Nov 2009 10:57:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.32-rc8
Message-ID: <20091118015715.GA8751@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.32

Which contains:

Kuninori Morimoto (1):
      uio: pm_runtime_disable is needed if failed

Thomas Gleixner (1):
      sh: Fixup last users of irq_chip->typename

 arch/sh/kernel/cpu/irq/imask.c    |    2 +-
 arch/sh/kernel/cpu/irq/intc-sh5.c |    2 +-
 drivers/uio/uio_pdrv_genirq.c     |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)
