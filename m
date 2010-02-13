Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab0BMND2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 08:03:28 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:49010 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab0BMND0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:03:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DWNVJvtV9jo04MTG3gPkkLSJjlJ3Y8vRWrieyfkSx6kUGXO7WdG3+LT0TuLODaH6XA
         D8EZTKOvGgmqH1AEXFU/XU3ddsXjhc1xvVrLDYr31tbh3vLKDbZr7wirvroj/uqNF7Sm
         3WcJs94lN6/d3bW+klcaoO42nttuNKvOI5wL4=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>
Subject: [PATCH 0/14 V8] Work to enable SmartMedia/xD support in mtd
Date: Sat, 13 Feb 2010 15:02:59 +0200
Message-Id: <1266066193-17625-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is next version of my patches, and it fixes many problems.

First of all, I have rewriiten the hotplug fixes.
Now I hope there are no races and memory leaks.
Although I still add an unlocked version of get/put_mtd_device I use that only
with mtd_table_mutex held.

Patch #10 is also new, and it allows me to reuse the default nand_block_bad

As usuall, few fixes there and there, few memory leaks fixed thanks to kmemleak

Best regards,
	Maxim Levitsky

