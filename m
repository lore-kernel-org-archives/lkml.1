Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbXFYJAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbXFYJAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 05:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbXFYJA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 05:00:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52506 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750853AbXFYJA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 05:00:26 -0400
Date: Mon, 25 Jun 2007 10:06:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Nobin Mathew" <nobin.mathew@gmail.com>
Cc: "Carlo Wood" <carlo@alinoe.com>,
       "Tomasz =?UTF-8?B?S8WCb2N6a28=?=" <kloczek@rudy.mif.pg.gda.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070625100618.3653863d@the-village.bc.nu>
In-Reply-To: <8d6898730706242041q61f56b07kf4dc181fdad4e4dc@mail.gmail.com>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
	<20070624200837.16e11305@the-village.bc.nu>
	<Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
	<20070624215724.025a5de5@the-village.bc.nu>
	<20070624224411.GB21724@alinoe.com>
	<8d6898730706242041q61f56b07kf4dc181fdad4e4dc@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If it is native ALSA driver then it will restart after each underrun
> and overrun. It is the applications job to do this, alsa-lib provides
> all support for this. I have no idea of OSS and OSS emulation in ALSA.

OSS should autorestart on underrun and just moan about overruns and drop
bits. So if it's not following that behaviour he is IMHO correct for the
OSS emulation case.
