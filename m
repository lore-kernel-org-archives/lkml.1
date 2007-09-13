Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbXIMLjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbXIMLjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 07:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbXIMLjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 07:39:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:60387 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbXIMLjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 07:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=PQJAkJxhfE1n/zhYBSGwHPOcqciC9+U+7UpX+5CeIWtwLqok48GgzAPz5TpSJVDbW2s8ltqnELF8cXhTT+RI4TgNwVWEvg99QYkvJ/UTXvCrCEen8Kw2AEVg7cWS9E9ysE1c/K04ysZlWxr7sM72DzKUcLkgoFBjKcySISr2L9M=
Message-ID: <46E92137.8020700@googlemail.com>
Date: Thu, 13 Sep 2007 13:38:31 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.23-rc6-git3-krf1
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are a few regression fixes in -krf tree

http://www.stardust.webpages.pl/files/patches/krf/2.6.23-rc6-git3/2.6.23-rc6-git3-krf1.patch.bz2
http://www.stardust.webpages.pl/files/patches/krf/2.6.23-rc6-git3/2.6.23-rc6-git3-krf1.tar.bz2

Vitaly Bordug:
	oops-while-modprobing-phy-fixed-module-fix.patch

Dmitry Torokhov:
	sysfs-change-of-input-event-devices-in-2.6.23rc-breaks-udev-fix.patch

J. Bruce Fields:
	oops-in-nfs4_cb_recall-fix.patch

Jamal:
	possible-irq-lock-inversion-dependency-fix.patch

 drivers/base/core.c       |   29 +++-
 drivers/net/phy/Kconfig   |   14 ++
 drivers/net/phy/fixed.c   |  310 +++++++++++++++++++++++-----------------------
 fs/nfsd/nfs4callback.c    |    1
 fs/nfsd/nfs4state.c       |   37 +++--
 include/linux/phy_fixed.h |   38 +++++
 net/sched/act_api.c       |    8 -
 net/sched/act_police.c    |    4
 8 files changed, 258 insertions(+), 183 deletions(-)


Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
