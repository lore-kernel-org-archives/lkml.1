Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbYGDIed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbYGDIed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 04:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYGDIeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 04:34:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44707 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752630AbYGDIeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 04:34:24 -0400
Date: Fri, 4 Jul 2008 09:16:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <Uwe.Kleine-Koenig@digi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, "Hans J. Koch" <hjk@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio: User IRQ Mode
Message-ID: <20080704091629.66576eb7@lxorguk.ukuu.org.uk>
In-Reply-To: <20080704060108.GA11794@digi.com>
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se>
	<20080702125400.GC3199@local>
	<20080703071019.GC12214@digi.com>
	<20080703124505.GB3197@local>
	<aec7e5c30807032103p7626dcbdwe06c5fac461372c1@mail.gmail.com>
	<20080704060108.GA11794@digi.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	Note that this implies that the interrupt might be disabled for
> 	long periods, so this isn't usable for shared interrupt lines.

It isn't usable for shared lines anyway - because you would have deadlocks
