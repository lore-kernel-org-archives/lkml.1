Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbXK3Xoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbXK3Xoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbXK3XoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:44:20 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35182 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753130AbXK3XoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:44:19 -0500
Date: Fri, 30 Nov 2007 23:40:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bill Davidsen <davidsen@tmr.com>
Cc: David Newall <david@davidnewall.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Xavier Bestel <xavier.bestel@free.fr>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ben.Crowhurst@stellatravel.co.uk, linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071130234013.446f14ef@the-village.bc.nu>
In-Reply-To: <47509D56.7010605@tmr.com>
References: <474EAD18.6040408@stellatravel.co.uk>
	<1196416960.20567.205.camel@skunk.anacadf.mentorg.com>
	<20071130190742.4B7C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<1196418013.20567.211.camel@skunk.anacadf.mentorg.com>
	<Pine.LNX.4.64.0711301154070.3089@fbirervta.pbzchgretzou.qr>
	<47501C86.1020907@davidnewall.com>
	<47509D56.7010605@tmr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> BCPL was typeless, as was the successor B (between Bell Labs and GE we 

B isn't quite typeless. It has minimal inbuilt support for concepts like
strings (although you can of course multiply a string by an array
pointer ;))

It also had some elegances that C lost, notably 

	case 1..5:

the ability to do no zero biased arrays

	x[40];
	x-=10;

and the ability to reassign function names.

	printk = wombat;

as well as stuff like free(function);

Alan (who learned B before C, and is still waiting for P)
