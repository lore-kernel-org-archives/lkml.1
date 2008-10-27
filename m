Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbYJ0Tdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbYJ0Tdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYJ0Tdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:33:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46787
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbYJ0Tdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:33:38 -0400
Date: Mon, 27 Oct 2008 12:33:14 -0700 (PDT)
Message-Id: <20081027.123314.13620544.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: linux-next: Tree for October 27 (netdev/hp-plus)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081027121956.c21d06be.rdunlap@xenotime.net>
References: <20081027181725.8eb49b5e.sfr@canb.auug.org.au>
	<20081027121956.c21d06be.rdunlap@xenotime.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Mon, 27 Oct 2008 12:19:56 -0700

> Are there any outstanding patches in this area?
> 
> build-r5284.out:hp-plus.c:(.text+0x2b99a): undefined reference to `eip_interrupt'
> build-r5284.out:hp-plus.c:(.text+0x2ba0d): undefined reference to `eip_open'
> build-r5284.out:hp-plus.c:(.text+0x2baef): undefined reference to `eip_close'
> build-r5284.out:hp-plus.c:(.init.text+0x38ee): undefined reference to `NS8390p_init'
> build-r5284.out:(.init.text+0x3948): undefined reference to `__alloc_eip_netdev'
> build-r5284.out:make[1]: *** [.tmp_vmlinux1] Error 1

Grrr...  hp-plus.c uses the interfaces provided with 8390p.c but the Makefile
links it together with plain 8390.c

This is the most spectacular and longest standing build failure I've ever
seen to be honest :-)
