Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbYAAVXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbYAAVXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYAAVX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:23:27 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53533 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752038AbYAAVX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:23:26 -0500
Date: Tue, 1 Jan 2008 21:13:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christer Weinigel <christer@weinigel.se>
Cc: Ingo Molnar <mingo@elte.hu>, "David P. Reed" <dpreed@reed.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101211322.29697e88@the-village.bc.nu>
In-Reply-To: <20080101211449.1f39da07@weinigel.se>
References: <4765DCB0.8030901@gmail.com>
	<4765EE7F.80002@zytor.com>
	<47667366.7010405@gmail.com>
	<4766AE88.4080904@zytor.com>
	<4766D175.7040807@reed.com>
	<20071217212509.5edaa372@the-village.bc.nu>
	<477A634C.8040000@reed.com>
	<20080101161557.3ce2d5f8@the-village.bc.nu>
	<20080101164338.GA901@elte.hu>
	<20080101173212.1bba4939@the-village.bc.nu>
	<20080101184524.GA6655@elte.hu>
	<20080101211449.1f39da07@weinigel.se>
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

> How do you find out the speed of the ISA bus?  AFAIK there is no
> standardized way to do that.  On the Geode SC2200 the ISA bus speed is

It is per chipset magic registers. Fun fun fun

> usually the PCI clock divided by 4 giving 33MHz/4=8.3MHz or
> 30/4=7.5MHz, but with no external ISA devices it's possible to
> overclock the ISA bus to /3 to run it at 11MHz or so.  But without

12MHz is valid for ISA although not a good idea - even IBM issued some
systems with 12MHz ISA before discovering many vendors had assumed 8 was
it.
