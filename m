Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbYHGAWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbYHGAWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYHGAWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 20:22:03 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53460 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbYHGAWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 20:22:01 -0400
Date: Wed, 6 Aug 2008 17:21:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for August 6 (8390 et al)
Message-Id: <20080806172148.7fac5999.randy.dunlap@oracle.com>
In-Reply-To: <20080806182828.6bfe0a16.sfr@canb.auug.org.au>
References: <20080806182828.6bfe0a16.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One randconfig ends with:

drivers/built-in.o: In function `wd_probe1':
wd.c:(.init.text+0x6179): undefined reference to `NS8390p_init'
make[1]: *** [.tmp_vmlinux1] Error 1


and another one ends with:

ERROR: "ei_close" [drivers/net/hp-plus.ko] undefined!
ERROR: "ei_open" [drivers/net/hp-plus.ko] undefined!
ERROR: "ei_interrupt" [drivers/net/hp-plus.ko] undefined!
ERROR: "__alloc_ei_netdev" [drivers/net/hp-plus.ko] undefined!
make[2]: *** [__modpost] Error 1



---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
