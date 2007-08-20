Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbXHTCRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbXHTCRO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 22:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbXHTCQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 22:16:59 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:39215 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755195AbXHTCQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 22:16:58 -0400
Date: Mon, 20 Aug 2007 11:16:54 +0900 (JST)
Message-Id: <20070820.111654.63743265.nemoto@toshiba-tops.co.jp>
To: david-b@pacbell.net
Cc: kay.sievers@vrfy.org, jengelh@computergmbh.de, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       greg@kroah.com
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <200708191902.04966.david-b@pacbell.net>
References: <1187559950.4419.79.camel@lov.localdomain>
	<200708191848.21410.david-b@pacbell.net>
	<200708191902.04966.david-b@pacbell.net>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2007 19:02:04 -0700, David Brownell <david-b@pacbell.net> wrote:
> This is indeed a platform driver.  And v2 of this patch
> doesn't resolve its "won't hotplug" problem.  The simplest
> way to resolve that would be switching to the more widely
> used platform_device_register().

Yes, if the current in-tree users (JMR3927 and RBTX4927 board) really
wanted to hotplug this driver.  And I believe they won't :-)

I just want to fix a potential problem in rtc-ds1742 driver for
someone who want to hotplug it.  That's all.

---
Atsushi Nemoto
