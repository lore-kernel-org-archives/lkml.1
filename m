Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbZJEVFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbZJEVFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZJEVFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:05:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34045
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbZJEVFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:05:41 -0400
Date: Mon, 05 Oct 2009 14:05:35 -0700 (PDT)
Message-Id: <20091005.140535.205685992.davem@davemloft.net>
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


Here is the PIO-0 revert as well as a printk_once conversion.

Please pull, thanks a lot!

The following changes since commit 90d5ffc729e92bffc0f84e2447e2e6dc280240a5:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

David S. Miller (1):
      Revert "ide: try to use PIO Mode 0 during probe if possible"

Marcin Slusarz (1):
      ide: use printk_once

 drivers/ide/ide-probe.c |    9 ---------
 drivers/ide/ide-proc.c  |    8 +-------
 2 files changed, 1 insertions(+), 16 deletions(-)
