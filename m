Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbZJ2Ogf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbZJ2Ogf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZJ2Oge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:36:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49596
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753813AbZJ2Oge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:36:34 -0400
Date: Thu, 29 Oct 2009 07:36:57 -0700 (PDT)
Message-Id: <20091029.073657.161810259.davem@davemloft.net>
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


Just once bug fix from Mikulas Patocka, need to add back serialization
flag to some CMD64X chip variants.

Please pull, thanks a lot!

The following changes since commit 964fe080d94db82a3268443e9b9ece4c60246414:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

Mikulas Patocka (1):
      ide: Serialize CMD643 and CMD646 to fix a hardware bug with SSD

 drivers/ide/cmd64x.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)
