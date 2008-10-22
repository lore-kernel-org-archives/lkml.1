Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYJVIfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYJVIfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 04:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYJVIfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 04:35:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41276 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752540AbYJVIfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 04:35:17 -0400
Date: Wed, 22 Oct 2008 09:34:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: kgdb 2.6.28 merge plans
Message-ID: <20081022093413.23245ab6@lxorguk.ukuu.org.uk>
In-Reply-To: <48FE8B6F.3050406@windriver.com>
References: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com>
	<20081021234911.3813f17d@lxorguk.ukuu.org.uk>
	<48FE8B6F.3050406@windriver.com>
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

>       tty: Fix sparse static warning for tty_driver_lookup_tty
>       kgdboc, tty: Add the rx polling call back capability
>       kgdboc, 8250: rx polling hook for the 8250 driver
>       kgdboc, amba-pl011: rx polling hook for the amba-pl011 driver

This is not 2.6.28 tty layer or serial layer material. The tty driver
tree has been building patches for 2.6.28 for several weeks. Everyone
else managed to send me patches before the big push to Linus to get them
integrated, you didn't.

In addition to which random hooks in random mixtures of uart drivers are
not a practical sensible way to manage general purpose interfaces to
debug tools.

NAK.

You missed the window and the stuff presented simply isn't ready to go
upstream.
