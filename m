Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbYAHOlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbYAHOlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 09:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbYAHOlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 09:41:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43925 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753413AbYAHOlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 09:41:10 -0500
Date: Tue, 8 Jan 2008 14:38:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Bodo Eggert <7eggert@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       "David P. Reed" <dpreed@reed.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080108143814.472711ab@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LSU.0.999.0801081352080.12636@be1.lrz>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	<9BeZN-3Gf-5@gated-at.bofh.it>
	<9BnTB-1As-31@gated-at.bofh.it>
	<9BrX4-8go-1@gated-at.bofh.it>
	<9BuBG-4eR-51@gated-at.bofh.it>
	<9BvRd-6aL-71@gated-at.bofh.it>
	<9GRQW-1DX-13@gated-at.bofh.it>
	<9GSah-23W-1@gated-at.bofh.it>
	<9GSDy-2GD-23@gated-at.bofh.it>
	<9GTpK-40d-15@gated-at.bofh.it>
	<9GUvy-5H2-11@gated-at.bofh.it>
	<9GVKU-7SS-25@gated-at.bofh.it>
	<E1JBxnV-00046d-CS@be1.7eggert.dyndns.org>
	<478281A6.1000704@zytor.com>
	<alpine.LSU.0.999.0801072226060.16143@be1.lrz>
	<20080107232514.699155d6@lxorguk.ukuu.org.uk>
	<alpine.LSU.0.999.0801081352080.12636@be1.lrz>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As long as there is no port 80 card or a similar device using it. If 
> there is a port 80 card, ISA acess needing the delay does break

Such cards are very unusual on ISA machines and it hasn't been a problem
in fifteen years. All the alternatives are vastly higher risk
