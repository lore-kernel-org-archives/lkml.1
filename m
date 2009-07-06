Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbZGFVvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbZGFVvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZGFVvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:51:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39555
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059AbZGFVvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:51:38 -0400
Date: Mon, 06 Jul 2009 14:51:44 -0700 (PDT)
Message-Id: <20090706.145144.173645961.davem@davemloft.net>
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


This reverts a power-management fix we tried a week ago.

It doesn't work and it looks like we'll need to attack this in 2.6.32
instead.

Please pull, thanks a lot.

The following changes since commit 8e4a718ff38d8539938ec3421935904c27e00c39:
  Linus Torvalds (1):
        Linux 2.6.31-rc2

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

David S. Miller (1):
      Revert "ide: improve handling of Power Management requests"

 drivers/ide/ide-io.c |   54 +++++++++++++++++++++++++++++--------------------
 1 files changed, 32 insertions(+), 22 deletions(-)
