Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbXFDOj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbXFDOj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756457AbXFDOjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:39:41 -0400
Received: from khc.piap.pl ([195.187.100.11]:52066 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756438AbXFDOjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:39:40 -0400
To: lkml <linux-kernel@vger.kernel.org>
Subject: IXP4xx network drivers: current status
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 04 Jun 2007 16:39:37 +0200
Message-ID: <m3r6orpyvq.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just put the latest drivers in git:

git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux-2.6.git

currently ixp4xx-21 branch only (= based on 2.6.21).

Qmgr, NPE, Ethernet, HSS. This is my "export" repository, it doesn't
contain the history, though I'll try not to rebase it (or otherwise
make hard to merge).

It's not currently intended for mainstream inclusion, though it seems
stable at the moment (at least on my IXP425 rev B0).

1. Problems with draining RX descriptors fixed (Ethernet only - HSS
   firmware had no such issues)
2. Seems to work fine in both LE (data swapping) and BE modes (I haven't
   yet looked at LE data-coherency mode)
3. "Irqchip" not yet implemented (nor investigated). It will have to
   wait a bit.
4. Still uses Intel's format for firmware files. Honestly, I don't
   like it.

Ok. Now I'm leaving for ~ 3 weeks, so don't expect much from me in this
time.
-- 
Krzysztof Halasa
