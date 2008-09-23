Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYIWWl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYIWWl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYIWWlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:41:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:52132 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYIWWlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:41:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding:sender;
        b=wx7ETjGVEDZOewHZQ4LeziPc3ySlS2KbjX9FhY8pLOJzKNGsQJyrW+B0TL3TVYMw/Y
         LX+czORkyfn1WwgeT8E0aDMrckdaFiA1QDcr5eh/pNiYTXZbPWeI/H0K7sm4fvXh2tI4
         uzKIRcceHqv1M5LgMVwx22DKLmRwSN1rOSPiU=
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 0/3] e1000e: protect NVM from corruption
To: jeff@garzik.org, davem@davemloft.net, mingo@elte.hu
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com, john.ronciak@intel.com
Date: Tue, 23 Sep 2008 15:41:33 -0700
Message-ID: <20080923224106.15640.28678.stgit@gitlost.lost>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches apply against commit e002bcc2f8e766a96472379e3b4a8a4e8938a93e of Linus's latest tree.

These patches have had some basic tested run against them.  These patches are intended to prevent the NVM corruption being reported and will hopefully help in finding a root cause for the NVM corruption.

---

Bruce Allan (3):
      e1000e: remove failed request for sw/fw/hw flag
      e1000e: Useset_memory_ro()/set_memory_rw() to protect flash memory
      x86: export set_memory_ro() and set_memory_rw() calls


 arch/x86/mm/pageattr.c       |    2 ++
 drivers/net/e1000e/e1000.h   |    1 +
 drivers/net/e1000e/hw.h      |    1 +
 drivers/net/e1000e/ich8lan.c |   18 ++++++++++++++++++
 drivers/net/e1000e/netdev.c  |   11 +++++++----
 5 files changed, 29 insertions(+), 4 deletions(-)

-- 
Signature
