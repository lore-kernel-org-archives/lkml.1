Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0BVSj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:39:57 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56979 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab0BVSjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:39:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kDEqXJN0TOIofklkI4l+u54CA6mX9DGEqAgwEN/g5wmNOsncOSaxA/OgsVH8t2AZ30
         jucyxWsRtzged8ME49Jd3NeZYXRC0XDybRvBPEQM6+wnSxZ+WNstwoGkiqFbRO92vM4d
         p0yfatJbpdBKvAxYHtcZvRXCfJQNn14sPTOOo=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>, <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>
Subject: [PATCH 0/15 V10] Work to enable SmartMedia/xD support in mtd
Date: Mon, 22 Feb 2010 20:39:27 +0200
Message-Id: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:

* Rebased the series against patches from Ben Hutchings.
Now it applies cleanly on top of
git://git.infradead.org/users/dedekind/l2-mtd-2.6.git

* Fixed another blktrans hotplug problem. 
If you remove that card while it is used, then add it while,
the user still holds the block device open, block device wasn't accesable

* Fixed minor memory leak in mtdblock (unrelated to the patchset)

Best regards,
	Maxim Levitsky

