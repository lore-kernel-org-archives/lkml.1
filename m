Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbYAAXWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbYAAXWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbYAAXWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:22:22 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56539 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754907AbYAAXWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:22:21 -0500
Date: Tue, 1 Jan 2008 23:12:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christer Weinigel <christer@weinigel.se>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "David P. Reed" <dpreed@reed.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101231250.054b7352@the-village.bc.nu>
In-Reply-To: <20080102000545.5c68f183@weinigel.se>
References: <4765DCB0.8030901@gmail.com>
	<4765EE7F.80002@zytor.com>
	<47667366.7010405@gmail.com>
	<4766AE88.4080904@zytor.com>
	<4766D175.7040807@reed.com>
	<20071217212509.5edaa372@the-village.bc.nu>
	<477A634C.8040000@reed.com>
	<20080101161557.3ce2d5f8@the-village.bc.nu>
	<20080101164338.GA901@elte.hu>
	<20080101183238.74307174@weinigel.se>
	<20080101184659.GA9250@elte.hu>
	<20080101203518.26e889f2@weinigel.se>
	<477AAEEB.5060407@zytor.com>
	<20080102000545.5c68f183@weinigel.se>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Besides the above there are only a handful of _p uses outside of real
> ISA device drivers, and those should not be relevant for a modern PC
> unless somebody wants to use an 8390 based PCMCIA card, but we could
> tell them "don't do that then".

We need to build 8390.c twice anyway - once for PCI once for ISA with the
_p changes whichever way it gets done. PCMCIA can use whichever we decide
is right. Anyone know if PCMCIA is guaranteed to be 8MHz ?
