Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0BIQ57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 11:57:59 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:65144 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab0BIQ56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 11:57:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Zjp4hqFdAqRCxYv7m5ePb5VY677JfAdWe1IVOjPsUH6XEFjYFC6j9E2R4RorbCI9ta
         nZ0H25HXdA3f/RSbckKlx9+FuuVCoFd1C3G618HkwPtUV4Ic5jqG8cQy6KEWz10c2tgJ
         7jeTJucrobrWVO6ED+34UgfN0q/8zbVcw+ioA=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>
Subject: [PATCH 0/17 V7] Work to enable SmartMedia/xD support in mtd subsystem
Date: Tue,  9 Feb 2010 18:57:28 +0200
Message-Id: <1265734665-22656-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is next version of my work.


Patches #1-#8 fix hotplug in mtd block translation layer
(Patch #7 adds minor feature for FTL drivers to be able to export sysfs attributes)

Patches #9-#13 fix several issues in NAND subsystem

Patch #16 adds a driver for my xD card reader.
I hope that writing drivers for other readers won't be that hard now.

Patch #17 adds generic SmartMedia/xD FTL

Best regards,
	Maxim Levitsky

