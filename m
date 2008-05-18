Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbYERSCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbYERSCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYERSCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:02:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43606 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752250AbYERSCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:02:40 -0400
Date: Sun, 18 May 2008 18:51:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
Message-ID: <20080518185104.0a539f25@core>
In-Reply-To: <48306DCA.9070108@t-online.de>
References: <4829326A.6060808@t-online.de>
	<19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com>
	<4829D345.7020909@t-online.de>
	<19f34abd0805140034j75d97ecbw5a03c200645768cb@mail.gmail.com>
	<482B1BD2.8040400@t-online.de>
	<19f34abd0805141017g26c13e96t2e7edc23bec263d0@mail.gmail.com>
	<20080514183558.40178fe5@core>
	<48306DCA.9070108@t-online.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This GDB was configured as "x86_64-linux-gnu"...
> Attaching to program: /var/tmp/coreutils-6.10/coreutils-6.10/src/stty, process 26465
> /tmp/buildd/gdb-6.8/gdb/linux-nat.c:988: internal-error: linux_nat_attach: Assertion `pid == GET_PID (inferior_ptid) && WIFSTOPPED (status) && WSTOPSIG (status) == SIGSTOP' failed.
> A problem internal to GDB has been detected,

So your gdb is broken, your stty is doign stuff nobody else seems to be
seeing ? My first thought is to suspect the distro/source as I've still
had no other equivalent reports and given the gdb spew.

I'll have a dig further however as the GDB spew itself might actually be
a useful clue. Not sure I can do much without a proper trace however (if
gdb is borked on your box is strace giving sane reports ?)


Alan
