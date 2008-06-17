Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbYFQVzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbYFQVzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbYFQVzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:55:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39736 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755652AbYFQVzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:55:37 -0400
Date: Tue, 17 Jun 2008 22:38:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Nameer Yarkon" <nameer.yarkon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Serial problem and request for guidance..
Message-ID: <20080617223809.56d65635@lxorguk.ukuu.org.uk>
In-Reply-To: <bec9a5870806171433gf74e251m6742e066960d6ab4@mail.gmail.com>
References: <bec9a5870806160514w79448b53ya622f4752253ae5b@mail.gmail.com>
	<20080616130353.1b80fdd0@lxorguk.ukuu.org.uk>
	<bec9a5870806171433gf74e251m6742e066960d6ab4@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> on ARM (OMAP) with an old 2.6.14 kernel, but only when I enable the
> debug macros of the line discipline code (hci_h4, hci_ldisc,..).
> When a big chunk of data arrives, more than
> half of it is lost. even on 115200. But when I turn of the debug macros (BT_DBG

Not a suprise. The old buffering would struggle in this case.

> macros which are simply a bunch of prinks) the problem disappears. So I suspect
> there are some nasty timing issues which lead to data loss.
> 
> I encountered similar problems last year even on a PC, with pre 2.6.21 kernels
> (around 2.6.19 or even earlier IIRC) but it was all gone with 2.6.21 and 2.6.22.

We rewrote the tty buffering around the point it magically started
working so that would fit my suspicion.

Alan
