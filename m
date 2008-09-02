Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYIBJgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYIBJgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 05:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYIBJgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 05:36:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48087 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750894AbYIBJgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 05:36:08 -0400
Date: Tue, 2 Sep 2008 10:17:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
Message-ID: <20080902101749.3056197a@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net>
	<alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de>
	<48BC2A03.9000104@lwfinger.net>
	<alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On the machine you have trouble with the PIT on, does this thing trigger?
> 
> If it does, that could be a simple way to say whether you prefer PM_TIMER 
> over PIT.

You'll get funny answers on the Geode doing that. It will also randomly
mistrigger on some laptops - they don't use SMI for PIC but their power
handling SMIs will trigger that randomly.

PMTimer may also be an SMI too btw.

Alan
