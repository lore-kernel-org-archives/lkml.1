Return-Path: <linux-kernel-owner+w=401wt.eu-S1030650AbXBMEWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030650AbXBMEWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 23:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030655AbXBMEWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 23:22:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35017
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030649AbXBMEWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 23:22:01 -0500
Date: Mon, 12 Feb 2007 20:22:00 -0800 (PST)
Message-Id: <20070212.202200.55506607.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: clem@clem.clem-digital.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.20-git8 fails compile -- net/built-in.o __ipv6_addr_type
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070212181216.c55ca788.akpm@linux-foundation.org>
References: <200702130110.l1D1ADai012897@clem.clem-digital.net>
	<20070212181216.c55ca788.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 12 Feb 2007 18:12:16 -0800

> > On Mon, 12 Feb 2007 20:10:13 -0500 (EST) Pete Clements <clem@clem.clem-digital.net> wrote:
> > 2.6.20-git8 fails compile:
> > 
> >   CHK     include/linux/compile.h
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > net/built-in.o: In function `svc_udp_recvfrom':
> > svcsock.c:(.text+0x61be4): undefined reference to `__ipv6_addr_type'
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> 
> Please send the .config.

Not necessary, the bug is obvious, see my other reply to
this report.
