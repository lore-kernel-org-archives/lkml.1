Return-Path: <linux-kernel-owner+w=401wt.eu-S1761242AbYAKOlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761242AbYAKOlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758444AbYAKOlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:41:25 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44047 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755898AbYAKOlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:41:24 -0500
Date: Fri, 11 Jan 2008 14:37:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Zachary Amsden <zach@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
Message-ID: <20080111143748.35883ff7@lxorguk.ukuu.org.uk>
In-Reply-To: <47877ECD.9060408@reed.com>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	<200801081810.58904.linux@rainbow-software.org>
	<4783B1B2.6070005@reed.com>
	<200801081838.16241.linux@rainbow-software.org>
	<4783C4A6.9060402@reed.com>
	<20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>
	<4783CBD9.7020709@reed.com>
	<1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>
	<47845972.9090803@zytor.com>
	<1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>
	<47854916.4080703@reed.com>
	<1200015388.6192.22.camel@bodhitayantram.eng.vmware.com>
	<4786DD05.20804@keyaccess.nl>
	<47877ECD.9060408@reed.com>
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

> bus abort on the LPC bus".   More problematic is that I would think some 
> people might want to turn on the AMD feature that generates machine 
> checks if a bus timeout happens.   The whole point of machine checks is 

An ISA/LPC bus timeout is fulfilled by the bridge so doesn't cause an MCE.

Alan
