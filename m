Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbZJGLK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbZJGLK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZJGLK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:10:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44296
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753458AbZJGLK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:10:27 -0400
Date: Wed, 07 Oct 2009 04:10:23 -0700 (PDT)
Message-Id: <20091007.041023.205207417.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get the sis5513 PIO bug fix from Bart, and
the revert that is no longer necessary as the real problem
is now solved.

Thanks!

The following changes since commit 0eca52a92735f43462165efe00a7e394345fb38e:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

Bartlomiej Zolnierkiewicz (2):
      sis5513: fix PIO setup for ATAPI devices
      Revert "Revert "ide: try to use PIO Mode 0 during probe if possible""

 drivers/ide/ide-probe.c |    9 +++++++++
 drivers/ide/sis5513.c   |   10 ++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)
