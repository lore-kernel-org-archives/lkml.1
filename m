Return-Path: <linux-kernel-owner+w=401wt.eu-S1761127AbYDYKCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761127AbYDYKCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 06:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759086AbYDYKCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 06:02:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59174 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758496AbYDYKCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:02:23 -0400
Date: Fri, 25 Apr 2008 10:55:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Yang, Graf" <Graf.Yang@analog.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <graf.yang@analog.com>
Subject: Re: Blackfin Serial Driver: Enable IR function when user
 application (irattach /dev/ttyBFx -s) call TIOCSETD ioctl with line
 discipline N_IRDA
Message-ID: <20080425105545.77b8c5e8@core>
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA0164BC7A@chinexm1.ad.analog.com>
References: <200804241929.m3OJToSE021045@hera.kernel.org>
	<20080424215004.34517136@the-village.bc.nu>
	<0F1B54C89D5F954D8535DB252AF412FA0164BC7A@chinexm1.ad.analog.com>
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

> Blackfin serial driver register as a UART driver, which will call tty_set_operations(...,&uart_ops), while uart_ops hasn't set_ldisc function.
> Do you mean I should declare a tty_ops and call tty_set_operations(..., &tty_ops) in bfin_5xx.c to register my set_ldisc?

Then we need to add a set_ldisc to uart_ops. I'll do that in todays
hacking.

Alan
