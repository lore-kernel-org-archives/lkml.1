Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYJGJvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYJGJvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 05:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYJGJvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 05:51:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47935 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751081AbYJGJvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 05:51:21 -0400
Date: Tue, 7 Oct 2008 10:37:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: avorontsov@ru.mvista.com, Matt Sealey <matt@genesi-usa.com>,
       Jeff Garzik <jgarzik@pobox.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Li Yang <leoli@freescale.com>, Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH] pata_of_platform: fix no irq handling
Message-ID: <20081007103723.0224671e@lxorguk.ukuu.org.uk>
In-Reply-To: <48EABBD3.1010401@kernel.org>
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
	<48EA77EF.6080502@genesi-usa.com>
	<20081006213209.GA13072@oksana.dev.rtsoft.ru>
	<48EABBD3.1010401@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This was discussed years ago.
> > 
> > http://lkml.org/lkml/2005/11/22/159
> > http://lkml.org/lkml/2005/11/22/227
> > 
> 
> Would this break any existing platforms?  If so, can those be fixed
> together or does it become a much bigger problem that way?

Zero means no IRQ. Any platform with bits of code left over exposing IRQ
0 is already not supported by lots of driver code including libata.

As IRQs are unsigned using -1 is asking for trouble
