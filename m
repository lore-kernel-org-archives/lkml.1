Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZG1TPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZG1TPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZG1TPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:15:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51530 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751406AbZG1TPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:15:52 -0400
Date: Tue, 28 Jul 2009 20:15:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090728201553.0eb2d51d@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
	<20090727145805.690afe5d@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp>
	<20090727161424.GA4233@skywalker>
	<20090727174252.2d987830@lxorguk.ukuu.org.uk>
	<20090727171213.GB4233@skywalker>
	<87skgikjr8.fsf@devron.myhome.or.jp>
	<20090727222010.1a5efb7b@lxorguk.ukuu.org.uk>
	<87r5w19xsb.fsf@devron.myhome.or.jp>
	<20090728112203.7b70adba@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280848090.3186@localhost.localdomain>
	<20090728174213.5e927428@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
	<20090728180649.596c5412@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281141070.3186@localhost.localdomain>
	<20090728195651.3a402a31@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Quite frankly, I don't understand why I should even have to bring these 
> issues up. You should have tried to fix the problem immediately, without 
> arguing against fixing the kernel. Without blaming user space. Without 
> making idiotic excuses for bad kernel behavior.
> 
> The fact is, breaking regular user applications is simply not acceptable. 
> Trying to blame kernel breakage on the app being "buggy" is not ok. And 
> arguing for almost a week against fixing it - that's just crazy.

I've been working on fixing it. I have spent a huge amount of time
working on the tty stuff trying to gradually get it sane without breaking
anything and fixing security holes along the way as they came up. I spent
the past two evenings working on the tty regressions.

However I've had enough. If you think that problem is easy to fix you fix
it.

Have fun.

I've zapped the tty merge queue so anyone with patches for the tty layer
can send them to the new maintainer.

--- MAINTAINERS~	2009-07-23 15:36:41.000000000 +0100
+++ MAINTAINERS	2009-07-28 20:09:32.200685827 +0100
@@ -5815,10 +5815,7 @@
 S:	Maintained
 
 TTY LAYER
-P:	Alan Cox
-M:	alan@lxorguk.ukuu.org.uk
-S:	Maintained
-T:	stgit http://zeniv.linux.org.uk/~alan/ttydev/
+S:	Unmaintained
 F:	drivers/char/tty_*
 F:	drivers/serial/serial_core.c
 F:	include/linux/serial_core.h
